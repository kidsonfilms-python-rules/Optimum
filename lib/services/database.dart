import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ftc_scouting_app/classes/match.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:ftc_scouting_app/classes/teamStats.dart';
import 'package:ftc_scouting_app/services/utils/ftcAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ValidationStatus { NOT_VALIDATED, IN_VALIDATION, VALID, INVALID }

class DatabaseService {
  List<FTCTeam> compTeams = [];
  List<FTCMatch> teamSchedule = [];
  List<FTCMatch> compSchedule = [];
  List<FTCMatch> matchResults = [];
  List<FTCMatch> teamMatchResults = [];
  Map<int, FTCTeam> userAlliancePartners = {};
  ValidationStatus validateTeamUsers = ValidationStatus.NOT_VALIDATED;
  int userTeamNumber = 0;
  String eventCodeG = "";

  Future<bool> initService(int teamID, String eventCode) async {
    print("initing database service...");
    eventCodeG = eventCode;
    userTeamNumber = teamID;
    Firebase.initializeApp();
    var compTeamsResults = await FTCAPI().getCompTeams(eventCode);
    var teamSchedResults =
        await FTCAPI().getTeamSchedule(eventCode, teamID, compTeamsResults);
    var compSchedResults =
        await FTCAPI().getCompSchedule(eventCode, teamID, compTeamsResults);
    var matchResultsRAW =
        await FTCAPI().getMatchResults(eventCode, teamID, compTeamsResults);
    var teamMatchResultsRAW =
        await FTCAPI().getTeamMatchResults(eventCode, teamID, compTeamsResults);

    for (var match in teamMatchResultsRAW) {
      userAlliancePartners[match.matchNumber] = match.userAlliancePartner;
    }

    compTeams = compTeamsResults;
    teamSchedule = teamSchedResults;
    compSchedule = compSchedResults;
    matchResults = matchResultsRAW;
    teamMatchResults = teamMatchResultsRAW;
    return true;
  }

  Future<List<FTCTeam>> getCompTeams() async {
    if (validateTeamUsers == ValidationStatus.NOT_VALIDATED) {
      validateTeamUsers = ValidationStatus.IN_VALIDATION;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var rankings = await FTCAPI().refreshTeamRankings(eventCodeG);
      for (var team in compTeams) {
        print(team.teamNumber);
        if (rankings
            .where((rank) => rank["teamNumber"] == team.teamNumber)
            .toList()
            .isNotEmpty) {
          var rank = rankings
              .where((rank) => rank["teamNumber"] == team.teamNumber)
              .toList()[0];
          var oldRank = team.stats.rank;
          team.stats.rank = rank["rank"];
          team.stats.wins = rank["wins"];
          team.stats.losses = rank["losses"];
          team.stats.totalTeams = compTeams.length;
          List<int> scores = [];
          for (var match in matchResults) {
            if (match.redAllianceTeams
                .where((element) => element.teamNumber == team.teamNumber)
                .toList()
                .isNotEmpty) {
              scores.add(match.redAllianceTotalPoints);
            } else if (match.blueAllianceTeams
                .where((element) => element.teamNumber == team.teamNumber)
                .toList()
                .isNotEmpty) {
              scores.add(match.blueAllianceTotalPoints);
            }
          }
          team.stats.scores = scores;
          team.stats.highScore =
              scores.reduce((curr, next) => curr > next ? curr : next);
          team.stats.trend = TeamStatsTrend.STABLE; //oldRank > team.stats.rank
          //     ? TeamStatsTrend.UP
          //     : (oldRank < team.stats.rank
          //         ? TeamStatsTrend.DOWN
          //         : TeamStatsTrend.STABLE);
        }

        await firestore
            .collection("teams")
            .doc(team.teamNumber.toString())
            .get()
            .then((value) {
          if (value.exists) {
            var teamData = value.data() as Map<String, dynamic>;
            team.isUser = true;
            team.teamNickname = teamData["nickname"];
            team.teamHeadliner = teamData["headliner"];
            team.teamMatch = 50;
            team.teamStrengths = teamData["strengths"];
            team.teamWeaknesses = teamData["weaknesses"];
            team.logo = teamData["logo"];
            team.robotThumbnail = teamData["robotThumbnail"];
            team.abilities = teamData["abilities"];
            team.theme = Color(teamData["theme"]);
          }
        });
      }
      validateTeamUsers = ValidationStatus.VALID;
      print("Validated Teams!");
      compTeams.sort(((a, b) => b.teamMatch.compareTo(a.teamMatch)));
      return compTeams;
    }
    return compTeams;
  }

  Future<FTCTeam> getTeam(int teamNumber) async {
    if (validateTeamUsers == ValidationStatus.NOT_VALIDATED) {
      validateTeamUsers = ValidationStatus.IN_VALIDATION;
      var rankings = await FTCAPI().refreshTeamRankings(eventCodeG);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      for (var team in compTeams) {
        firestore
            .collection("teams")
            .doc(team.teamNumber.toString())
            .get()
            .then((value) {
          if (value != null) {
            var teamData = value.data() as Map<String, dynamic>;
            team.isUser = true;
            team.teamNickname = teamData["nickname"];
            team.teamHeadliner = teamData["headliner"];
            team.teamMatch = 50;
            team.teamStrengths = teamData["strengths"];
            team.teamWeaknesses = teamData["weaknesses"];
            team.abilities = teamData["abilities"];
            team.logo = teamData["logo"];
            team.robotThumbnail = teamData["robotThumbnail"];
            var rank = rankings
                .where((rank) => rank["teamNumber"] == team.teamNumber)
                .toList()[0];
            var oldRank = team.stats.rank;
            team.stats.rank = rank["rank"];
            team.stats.wins = rank["wins"];
            team.stats.losses = rank["losses"];
            team.stats.trend = oldRank > team.stats.rank
                ? TeamStatsTrend.UP
                : (oldRank < team.stats.rank
                    ? TeamStatsTrend.DOWN
                    : TeamStatsTrend.STABLE);
          }
        });
      }
      validateTeamUsers = ValidationStatus.VALID;
      print("Validated Teams!");
    }
    return compTeams.where((team) => team.teamNumber == teamNumber).toList()[0];
  }

  FTCMatch getNextMatch() {
    int i = 0;
    int minFutureMatch = teamSchedule.length - 1;
    while (i > teamSchedule.length) {
      if (teamSchedule[i].startTime.compareTo(DateTime.now()) <
              teamSchedule[minFutureMatch]
                  .startTime
                  .compareTo(DateTime.now()) ||
          teamSchedule[i].startTime.compareTo(DateTime.now()) > 0) {
        minFutureMatch = i;
      }
    }
    return teamSchedule[minFutureMatch];
  }

  List<FTCMatch> getMatches() {
    return compSchedule;
  }

  List<FTCMatch> getTeamMatches() {
    return teamSchedule;
  }

  List<FTCMatch> getMatchResults() {
    return matchResults;
  }

  List<FTCMatch> getTeamMatchResults() {
    return teamMatchResults;
  }
}
