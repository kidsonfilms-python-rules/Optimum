import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/classes/match.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:ftc_scouting_app/classes/teamStats.dart';
import 'package:ftc_scouting_app/pages/discover.dart';
import 'package:ftc_scouting_app/pages/match_overview.dart';
import 'package:ftc_scouting_app/pages/team_profile.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final DatabaseService databaseService;
  const HomePage(this.databaseService, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(databaseService);
}

class _HomePageState extends State<HomePage> {
  final DatabaseService databaseService;
  _HomePageState(this.databaseService);

  FTCTeam userTeam = FTCTeam("", 0, 0, "", [], [], false,
      FTCTeamStats(1, 1, 1, 1, 1, [], [], TeamStatsTrend.STABLE));
  bool gotInfo = false;
  @override
  Widget build(BuildContext context) {
    if (!gotInfo) {
      databaseService.getCompTeams().then((teamsData) {
        setState(() {
          userTeam = teamsData
              .where((element) =>
                  element.teamNumber == databaseService.userTeamNumber)
              .toList()[0];
          gotInfo = true;
        });
      });
    }
    var nextMatch = databaseService.getNextMatch();
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      bottomNavigationBar: FluidNavBar(
        style: const FluidNavBarStyle(
            barBackgroundColor: Color.fromARGB(255, 20, 20, 20),
            iconBackgroundColor: Color.fromARGB(255, 58, 58, 58),
            iconSelectedForegroundColor: Color.fromRGBO(139, 255, 99, 1),
            iconUnselectedForegroundColor: Colors.white),
        animationFactor: 2,
        defaultIndex: 0,
        icons: [
          FluidNavBarIcon(icon: Icons.home),
          FluidNavBarIcon(icon: Icons.search),
          FluidNavBarIcon(icon: Icons.person)
        ],
        onChange: (n) {
          HapticFeedback.lightImpact();
          if (n == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DiscoverPage(databaseService)),
            );
          } else if (n == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeamProfilePage(databaseService)),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                "WELCOME BACK",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Poppins',
                    fontWeight: FontWeight.w200,
                    textStyle:
                        const TextStyle(fontSize: 48, color: Colors.white)),
              ),
              Card(
                color: const Color.fromRGBO(29, 29, 29, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            "  TEAM STATS",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            userTeam.stats.trend == TeamStatsTrend.UP
                                ? const Icon(Icons.arrow_drop_up,
                                    color: Color.fromRGBO(90, 255, 63, 1),
                                    size: 50.0)
                                : (userTeam.stats.trend == TeamStatsTrend.DOWN
                                    ? const Icon(Icons.arrow_drop_down,
                                        color: Color.fromRGBO(255, 63, 63, 1),
                                        size: 50.0)
                                    : const SizedBox(
                                        width: 50,
                                      )),
                            Column(
                              children: [
                                Text(
                                  "#" + userTeam.stats.rank.toString(),
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30)),
                                ),
                                Text(
                                  "RANK",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11)),
                                ),
                                Text(
                                  "OUT OF " +
                                      userTeam.stats.totalTeams.toString(),
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11)),
                                )
                              ],
                            )
                          ],
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 150,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: GridView.count(
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 5,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  childAspectRatio: 2,
                                  children: <Widget>[
                                    Text(
                                      userTeam.stats.wins.toString(),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        "WINS",
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    ),
                                    Text(
                                      userTeam.stats.losses.toString(),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        "LOSSES",
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    ),
                                    Text(
                                      userTeam.stats.highScore.toString(),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        "HIGH SCORE",
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 22),
              Card(
                semanticContainer: true,
                color: const Color.fromRGBO(29, 29, 29, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                          ),
                          Text(
                            "  NEXT MATCH",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              "MATCH",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ),
                            Text(
                              nextMatch.matchNumber.toString(),
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 30)),
                            )
                          ],
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 160,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: GridView.count(
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 5,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  childAspectRatio: 2,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Text(
                                      nextMatch.userAlliancePartner.teamNumber
                                          .toString(),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        "ALLIANCE PARTNER",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    ),
                                    Text(
                                      nextMatch.userAllianceColor ==
                                              AllianceColors.RED
                                          ? "RED"
                                          : "BLUE",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: TextStyle(
                                              color:
                                                  nextMatch.userAllianceColor ==
                                                          AllianceColors.RED
                                                      ? const Color.fromRGBO(
                                                          255, 63, 63, 1)
                                                      : const Color.fromRGBO(
                                                          54, 98, 255, 1),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        "ALLIANCE",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('h:mm a').format(nextMatch.startTime),
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7.0),
                                      child: Text(
                                        "START TIME",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    )
                                    // Text(
                                    //   "3",
                                    //   textAlign: TextAlign.end,
                                    //   style: GoogleFonts.getFont("Poppins",
                                    //       textStyle: const TextStyle(
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.w700,
                                    //           fontSize: 20)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 5.0),
                                    //   child: Text(
                                    //     "MATCHES TILL US",
                                    //     textAlign: TextAlign.left,
                                    //     style: GoogleFonts.getFont("Poppins",
                                    //         textStyle: const TextStyle(
                                    //             color: Colors.white,
                                    //             fontWeight: FontWeight.w600,
                                    //             fontSize: 12)),
                                    //   ),
                                    // )
                                  ])),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 22),
              Card(
                color: const Color.fromRGBO(29, 29, 29, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.gamepad,
                            color: Colors.white,
                          ),
                          Text(
                            "  ALLIANCE PARTNERS",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          )
                        ],
                      ),
                    ),
                    for (var match in databaseService.getTeamMatchResults())
                      Column(
                        children: [
                          (Row(
                            children: [
                              Text(
                                match.userAlliancePartner.teamNumber.toString(),
                                style: GoogleFonts.getFont("Poppins",
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11)),
                              ),
                              Text(
                                "    MATCH " + match.matchNumber.toString(),
                                style: GoogleFonts.getFont("Poppins",
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11)),
                              ),
                              Text(
                                "    " + (match.userAllianceColor == AllianceColors.RED ? match.redAllianceTotalPoints.toString() : match.blueAllianceTotalPoints.toString()) + " POINTS",
                                style: GoogleFonts.getFont("Poppins",
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11)),
                              ),
                              Text(
                                "   " + (match.userAllianceColor == match.winningAlliance ? "WIN" : "LOSS") + "    ",
                                style: GoogleFonts.getFont("Poppins",
                                    textStyle: TextStyle(
                                        color: match.userAllianceColor == match.winningAlliance ? const Color.fromRGBO(90, 255, 63, 1) : const Color.fromRGBO(255, 63, 63, 1),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11)),
                              ),
                              OutlinedButton(
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MatchOverviewPage(match)),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(34.0)),
                                    side: const BorderSide(
                                        width: 2.0,
                                        color: Color.fromRGBO(90, 255, 63, 1)),
                                  ),
                                  child: Text(
                                    "VIEW MATCH",
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color:
                                                Color.fromRGBO(90, 255, 63, 1),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9)),
                                  ))
                            ],
                          )),
                          const Divider(
                            color: Color.fromRGBO(155, 155, 155, 0.49),
                          ),
                        ],
                      ),
                  ]),
                ),
              ),
              const SizedBox(height: 44)
            ],
          ),
        ),
      ),
    );
  }
}
