// ignore_for_file: constant_identifier_names

import 'package:ftc_scouting_app/classes/team.dart';

enum AllianceColors { RED, BLUE, BOTH }
enum MatchStatus { UPCOMING, IN_PROGRESS, FINISHED }

class FTCMatch {
  int matchNumber;
  AllianceColors userAllianceColor;
  FTCTeam userAlliancePartner;
  List<FTCTeam> redAllianceTeams;
  List<FTCTeam> blueAllianceTeams;
  MatchStatus status;
  AllianceColors winningAlliance;
  int redAllianceTotalPoints;
  int blueAllianceTotalPoints;
  int redAllianceAutonPoints;
  int blueAllianceAutonPoints;
  int redAllianceFouls;
  int blueAllianceFouls;
  DateTime startTime;

  FTCMatch(this.matchNumber, this.userAllianceColor, this.userAlliancePartner,
      this.redAllianceTeams, this.blueAllianceTeams, this.status, this.startTime,
      {this.winningAlliance = AllianceColors.BOTH,
      this.redAllianceTotalPoints = 0,
      this.blueAllianceTotalPoints = 0,
      this.redAllianceAutonPoints = 0,
      this.blueAllianceAutonPoints = 0,
      this.redAllianceFouls = 0,
      this.blueAllianceFouls = 0});

  factory FTCMatch.fromJson(
      Map<String, dynamic> json, List<FTCTeam> teams, int teamNumber,
      {finished = false}) {
    AllianceColors allianceColor = json["teams"]
                .where((team) =>
                    team["station"].startsWith("Red") &&
                    team["teamNumber"] == teamNumber)
                .toList()
                .length >
            0
        ? AllianceColors.RED
        : (json["teams"]
                    .where((team) =>
                        team["station"].startsWith("Blue") &&
                        team["teamNumber"] == teamNumber)
                    .toList()
                    .length >
                0
            ? AllianceColors.BLUE
            : AllianceColors.BOTH);

    int allianceTeamNumber = json["teams"]
        .where((team) =>
            team["station"].startsWith(
                allianceColor == AllianceColors.RED ? "Red" : "Blue") &&
            team["teamNumber"] != teamNumber)
        .toList()[0]["teamNumber"];
    FTCTeam allianceTeam = teams
        .where((team) => team.teamNumber == allianceTeamNumber)
        .toList()[0];

    List<dynamic> redAllianceTeamsJSON = json["teams"]
        .where((team) => team["station"].startsWith("Red") && 2 == 2)
        .toList();

    List<FTCTeam> redAllianceTeams = teams
        .where((team) =>
            team.teamNumber == redAllianceTeamsJSON[0]["teamNumber"] ||
            team.teamNumber == redAllianceTeamsJSON[1]["teamNumber"])
        .toList();

    List<dynamic> blueAllianceTeamsJSON = json["teams"]
        .where((team) => team["station"].startsWith("Blue") && 2 == 2)
        .toList();

    List<FTCTeam> blueAllianceTeams = teams
        .where((team) =>
            team.teamNumber == blueAllianceTeamsJSON[0]["teamNumber"] ||
            team.teamNumber == blueAllianceTeamsJSON[1]["teamNumber"])
        .toList();

    return FTCMatch(
        json['matchNumber'],
        allianceColor,
        allianceTeam,
        // json["teams"][0]["teamNumber"],
        // json["teams"],
        // json["teams"],
        redAllianceTeams,
        blueAllianceTeams,
        finished ? MatchStatus.FINISHED : MatchStatus.UPCOMING,
        DateTime.parse(finished ? json["actualStartTime"] : json["startTime"]),
        winningAlliance: finished
            ? (json["scoreRedFinal"] > json["scoreBlueFinal"]
                ? AllianceColors.RED
                : (json["scoreRedFinal"] < json["scoreBlueFinal"]
                    ? AllianceColors.BLUE
                    : AllianceColors.BOTH))
            : AllianceColors.BOTH,
        blueAllianceTotalPoints: finished ? json["scoreBlueFinal"] : 0,
        redAllianceTotalPoints: finished ? json["scoreRedFinal"] : 0,
        redAllianceAutonPoints: finished ? json["scoreRedAuto"] : 0,
        blueAllianceAutonPoints: finished ? json["scoreBlueAuto"] : 0,
        redAllianceFouls: finished ? json["scoreRedFoul"] : 0,
        blueAllianceFouls: finished ? json["scoreBlueFoul"] : 0);
  }
}
