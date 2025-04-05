// ignore_for_file: constant_identifier_names

import 'package:ftc_scouting_app/classes/match.dart';

enum TeamStatsTrend { UP, DOWN, STABLE }

class FTCTeamStats {
  int rank;
  int totalTeams;
  int wins;
  int losses;
  int highScore;
  List<int> scores;
  List<FTCMatch> matches;
  TeamStatsTrend trend;

  FTCTeamStats(this.rank, this.totalTeams, this.wins, this.losses,
      this.highScore, this.scores, this.matches, this.trend);
}
