import 'package:flutter/material.dart';

class FTCTeam {
  String teamNickname;
  int teamNumber;
  double teamMatch;
  String teamHeadliner;
  List<String> teamStrengths;
  List<String> teamWeaknesses;
  bool isUser;
  bool following;
  String logo;
  String robotThumbnail;

  FTCTeam(
    this.teamNickname,
    this.teamNumber,
    this.teamMatch,
    this.teamHeadliner,
    this.teamStrengths,
    this.teamWeaknesses,
    this.isUser, {
    this.following = false,
    this.logo = "",
    this.robotThumbnail = "",
  });
}
