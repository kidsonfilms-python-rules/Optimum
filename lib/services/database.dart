// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftc_scouting_app/classes/match.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:ftc_scouting_app/classes/teamConnection.dart';
import 'package:ftc_scouting_app/classes/teamStats.dart';
import 'package:ftc_scouting_app/services/utils/ftcAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';

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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Cron scheduler = Cron();

  Future<bool> initService(
      int teamID, String eventCode, BuildContext context) async {
    print("initing database service...");
    eventCodeG = eventCode;
    userTeamNumber = teamID;
    var valid = await FTCAPI().compValid(eventCode, context);
    print("valid:" + valid.toString());
    if (valid) {
      var compTeamsResults = await FTCAPI().getCompTeams(eventCode);
      var teamSchedResults =
          await FTCAPI().getTeamSchedule(eventCode, teamID, compTeamsResults);
      var compSchedResults =
          await FTCAPI().getCompSchedule(eventCode, teamID, compTeamsResults);
      var matchResultsRAW =
          await FTCAPI().getMatchResults(eventCode, teamID, compTeamsResults);
      var teamMatchResultsRAW = await FTCAPI()
          .getTeamMatchResults(eventCode, teamID, compTeamsResults);

      for (var match in teamMatchResultsRAW) {
        userAlliancePartners[match.matchNumber] = match.userAlliancePartner;
      }

      compTeams = compTeamsResults;
      teamSchedule = teamSchedResults;
      compSchedule = compSchedResults;
      matchResults = matchResultsRAW;
      teamMatchResults = teamMatchResultsRAW;

      scheduler.schedule(Schedule.parse('*/2 * * * *'), () async {
        var teamSchedResults =
            await FTCAPI().getTeamSchedule(eventCode, teamID, compTeamsResults);
        var compSchedResults =
            await FTCAPI().getCompSchedule(eventCode, teamID, compTeamsResults);
        var matchResultsRAW =
            await FTCAPI().getMatchResults(eventCode, teamID, compTeamsResults);
        var teamMatchResultsRAW = await FTCAPI()
            .getTeamMatchResults(eventCode, teamID, compTeamsResults);

        teamSchedule = teamSchedResults;
        compSchedule = compSchedResults;
        matchResults = matchResultsRAW;
        teamMatchResults = teamMatchResultsRAW;
      });

      scheduler.schedule(Schedule.parse("*/30 * * * *"), () => validateTeams());

      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> userHasTeamSet(UserCredential user) async {
    var userUID = user.user?.uid;
    var userDoc = await firestore.collection("users").doc(userUID).get();
    if (!userDoc.exists) {
      await createUserRecord(user);
      userDoc = await firestore.collection("users").doc(userUID).get();
    }
    if (userDoc["teams"].isNotEmpty) {
      return userDoc.data()!["teams"][0];
    } else {
      return false;
    }
  }

  Future<bool> createUserRecord(UserCredential user) async {
    firestore.collection("users").doc(user.user?.uid).set({
      "uID": user.user?.uid,
      "teams": [],
      "name": user.user?.displayName,
      "profilePicture": user.user?.photoURL,
    });
    return true;
  }

  Future<bool> createTeamRecord(int teamNumber, UserCredential user) async {
    var _err = "";
    var teamDoc =
        await firestore.collection("teams").doc(teamNumber.toString()).get();
    if (teamDoc.exists) {
      firestore.collection("users").doc(user.user?.uid).update({
        "teams": [teamNumber]
      });
      return false;
    } else {
      await FTCAPI().getTeam(teamNumber).then((teamInfo) async {
        WriteBatch writeBatch = firestore.batch();
        writeBatch
            .set(firestore.collection("teams").doc(teamNumber.toString()), {
          "abilities": 0,
          "headliner":
              "Hi! I'm new to Optimum and still setting up my profile.",
          "logo": "",
          "nickname": teamInfo.teamNickname,
          "number": teamNumber,
          "robotThumbnail": "",
          "schemaVersion": 0.1,
          "theme": Colors.blueAccent.value,
          "strengths": ["Will eventually set this up", "hopefully"],
          "weaknesses": ["Not set up yet"]
        });

        writeBatch.update(firestore.collection("users").doc(user.user?.uid), {
          "teams": [teamNumber]
        });

        writeBatch.commit();
        return true;
      }, onError: (err) {
        _err = "team not exist: " + err.toString();
      });
    }
    if (_err != "") {
      print(_err);
      return false;
    }
    return true;
  }

  Future<bool> validateTeams() async {
    validateTeamUsers = ValidationStatus.IN_VALIDATION;
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
          List<TeamConnection> connections = [];
          teamData["connections"].forEach((connection) {
            connections.add(TeamConnection(
                connection["provider"] == "DISCORD"
                    ? TeamConnectionProvider.DISCORD
                    : (connection["provider"] == "EMAIL"
                        ? TeamConnectionProvider.EMAIL
                        : (connection["provider"] == "PHONE"
                            ? TeamConnectionProvider.PHONE
                            : (TeamConnectionProvider.WHATSAPP))),
                connection["username"]));
          });

          team.isUser = true;
          team.teamNickname = teamData["nickname"];
          team.teamHeadliner = teamData["headliner"];
          team.teamStrengths = teamData["strengths"];
          team.teamWeaknesses = teamData["weaknesses"];
          team.logo = teamData["logo"];
          team.robotThumbnail = teamData["robotThumbnail"];
          team.abilities = teamData["abilities"];
          team.theme = Color(teamData["theme"]);
          team.connections = connections;
        }
      });
      team.teamMatch = (((team.stats.highScore / 300) +
                  (team.stats.wins / (team.stats.wins + team.stats.losses)) +
                  ((1 / (team.stats.rank / team.stats.totalTeams)) /
                      team.stats.totalTeams)) /
              3) *
          100;
      print(team.teamNickname +
          ": " +
          (team.teamStrengths
                      .where((strength) => compTeams
                          .where(
                              (element) => element.teamNumber == userTeamNumber)
                          .toList()
                          .map((e) => e.teamWeaknesses)
                          .contains(strength))
                      .toList()
                      .length /
                  5)
              .toString() +
          "% match");
    }
    validateTeamUsers = ValidationStatus.VALID;
    print("Validated Teams!");
    return true;
  }

  Future<List<FTCTeam>> getCompTeams() async {
    if (validateTeamUsers == ValidationStatus.NOT_VALIDATED) {
      await validateTeams();
      compTeams.sort(((a, b) => b.teamMatch.compareTo(a.teamMatch)));
      return compTeams;
    }
    return compTeams;
  }

  Future<FTCTeam> getTeam(int teamNumber) async {
    if (validateTeamUsers == ValidationStatus.NOT_VALIDATED) {
      await validateTeams();
    }
    if (compTeams
        .where((team) => team.teamNumber == teamNumber)
        .toList()
        .isNotEmpty) {
      return compTeams
          .where((team) => team.teamNumber == teamNumber)
          .toList()[0];
    } else {
      throw "[OPTIMUM] [DATABASE SERVICE] FTC Team not found.";
    }
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

  Future<bool> updateTeam(FTCTeam newData) async {
    List<Map<String, dynamic>> connectionsParsed = [];
    for (var connection in newData.connections) {
      connectionsParsed.add({
        "provider": connection.provider.toString().split(".")[1].toUpperCase(),
        "username": connection.username
      });
    }
    await firestore
        .collection("teams")
        .doc(newData.teamNumber.toString())
        .update({
      "abilities": newData.abilities,
      "headliner": newData.teamHeadliner,
      "logo": newData.logo,
      "nickname": newData.teamNickname,
      "number": newData.teamNumber,
      "robotThumbnail": newData.robotThumbnail,
      "schemaVersion": 0.1,
      "strengths": newData.teamStrengths,
      "theme": newData.theme.value,
      "weaknesses": newData.teamWeaknesses,
      "connections": connectionsParsed
    });
    return true;
  }
}
