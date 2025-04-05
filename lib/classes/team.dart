import 'package:flutter/material.dart';
import 'package:ftc_scouting_app/classes/teamConnection.dart';
import 'package:ftc_scouting_app/classes/teamStats.dart';

class FTCTeam {
  String teamNickname;
  int teamNumber;
  double teamMatch;
  String teamHeadliner;
  List<dynamic> teamStrengths;
  List<dynamic> teamWeaknesses;
  bool isUser;
  bool following;
  String logo;
  String robotThumbnail;
  FTCTeamStats stats;
  int abilities;
  Color theme;
  List<TeamConnection> connections;

  FTCTeam(
    this.teamNickname,
    this.teamNumber,
    this.teamMatch,
    this.teamHeadliner,
    this.teamStrengths,
    this.teamWeaknesses,
    this.isUser,
    this.stats, {
    this.following = false,
    this.logo = "",
    this.robotThumbnail = "",
    this.abilities = 0,
    this.theme = Colors.blueAccent,
    this.connections = const [],
  });

  factory FTCTeam.fromJson(Map<String, dynamic> json, bool following) {
    return FTCTeam(
      json['nameShort'],
      json['teamNumber'],
      0,
      "This team has not joined Optimum yet, invite them to get better information on them.",
      [],
      [],
      false,
      FTCTeamStats(
          3, 48, 3, 1, 153, [123, 10, 133, 153], [], TeamStatsTrend.STABLE),
      following: following,
      connections: [],
    );
  }
}
