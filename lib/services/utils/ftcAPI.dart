import 'dart:convert';

import 'package:ftc_scouting_app/classes/match.dart';
import 'package:http/http.dart' as http;

import 'package:ftc_scouting_app/classes/team.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FTCAPI {
  List<FTCTeam> compTeams = [];

  Future<List<FTCTeam>> getCompTeams(String eventCode) async {
    List<FTCTeam> teams = [];
    final response = await http.get(
        Uri.parse(
            'https://ftc-api.firstinspires.org/v2.0/2021/teams?eventCode=' +
                eventCode),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonDecode(response.body)["teams"].forEach((team) async {
        var prefs = await SharedPreferences.getInstance();
        var following = prefs.getBool(
                        "following-" + team["teamNumber"].toString()) !=
                    null ||
                prefs.getBool("following-" + team["teamNumber"].toString()) !=
                    false
            ? true
            : false;
        teams.add(FTCTeam.fromJson(team, false));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load teams');
    }
    compTeams = teams;
    return teams;
  }

  Future<List<FTCMatch>> getTeamSchedule(
      String eventCode, int teamNumber, List<FTCTeam> teams) async {
    List<FTCMatch> matches = [];
    final response = await http.get(
        Uri.parse('https://ftc-api.firstinspires.org/v2.0/2021/schedule/' +
            eventCode +
            '?tournamentLevel=qual&teamNumber=' +
            teamNumber.toString()),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonDecode(response.body)["schedule"].forEach((match) {
        matches.add(FTCMatch.fromJson(
            match,
            teams
                .where((team) =>
                    team.teamNumber == match["teams"][0]["teamNumber"] ||
                    team.teamNumber == match["teams"][1]["teamNumber"] ||
                    team.teamNumber == match["teams"][2]["teamNumber"] ||
                    team.teamNumber == match["teams"][3]["teamNumber"])
                .toList(),
            teamNumber));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load schedule');
    }
    print(matches.map((e) => e.userAllianceColor));
    return matches;
  }

  Future<List<FTCMatch>> getCompSchedule(
      String eventCode, int teamNumber, List<FTCTeam> teams) async {
    List<FTCMatch> matches = [];
    final response = await http.get(
        Uri.parse('https://ftc-api.firstinspires.org/v2.0/2021/schedule/' +
            eventCode +
            '?tournamentLevel=qual'),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonDecode(response.body)["schedule"].forEach((match) {
        matches.add(FTCMatch.fromJson(
            match,
            teams
                .where((team) =>
                    team.teamNumber == match["teams"][0]["teamNumber"] ||
                    team.teamNumber == match["teams"][1]["teamNumber"] ||
                    team.teamNumber == match["teams"][2]["teamNumber"] ||
                    team.teamNumber == match["teams"][3]["teamNumber"])
                .toList(),
            teamNumber));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load schedule');
    }
    return matches;
  }

  Future<List<FTCMatch>> getMatchResults(
      String eventCode, int teamNumber, List<FTCTeam> teams) async {
    List<FTCMatch> matches = [];
    final response = await http.get(
        Uri.parse(
            'https://ftc-api.firstinspires.org/v2.0/2021/matches/' + eventCode),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    print("GeTting MATCH RESULTS");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonDecode(response.body)["matches"].forEach((match) {
        matches.add(FTCMatch.fromJson(
            match,
            teams
                .where((team) =>
                    team.teamNumber == match["teams"][0]["teamNumber"] ||
                    team.teamNumber == match["teams"][1]["teamNumber"] ||
                    team.teamNumber == match["teams"][2]["teamNumber"] ||
                    team.teamNumber == match["teams"][3]["teamNumber"])
                .toList(),
            teamNumber,
            finished: true));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load schedule');
    }
    print("GOT MATCH RESULTS");
    return matches;
  }
  Future<List<FTCMatch>> getTeamMatchResults(
      String eventCode, int teamNumber, List<FTCTeam> teams) async {
    List<FTCMatch> matches = [];
    final response = await http.get(
        Uri.parse(
            'https://ftc-api.firstinspires.org/v2.0/2021/matches/' + eventCode + '?teamNumber=' + teamNumber.toString()),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    print("GeTting MATCH RESULTS");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonDecode(response.body)["matches"].forEach((match) {
        matches.add(FTCMatch.fromJson(
            match,
            teams
                .where((team) =>
                    team.teamNumber == match["teams"][0]["teamNumber"] ||
                    team.teamNumber == match["teams"][1]["teamNumber"] ||
                    team.teamNumber == match["teams"][2]["teamNumber"] ||
                    team.teamNumber == match["teams"][3]["teamNumber"])
                .toList(),
            teamNumber,
            finished: true));
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load schedule');
    }
    print("GOT MATCH RESULTS");
    return matches;
  }

  Future<List<dynamic>> refreshTeamRankings(String eventCode) async {
    final response = await http.get(
        Uri.parse(
            'https://ftc-api.firstinspires.org/v2.0/2021/rankings/' + eventCode),
        headers: <String, String>{
          'authorization':
              "Basic [REDACTED]"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body)["Rankings"];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load schedule');
    }
  }
}
