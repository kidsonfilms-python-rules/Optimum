import 'package:flutter/material.dart';
import 'package:ftc_scouting_app/classes/match.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchOverviewPage extends StatefulWidget {
  final FTCMatch match;
  const MatchOverviewPage(this.match, {Key? key}) : super(key: key);

  @override
  _MatchOverviewPageState createState() => _MatchOverviewPageState(match);
}

class _MatchOverviewPageState extends State<MatchOverviewPage> {
  final FTCMatch match;
  _MatchOverviewPageState(this.match);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "MATCH " + match.matchNumber.toString(),
          style: GoogleFonts.getFont('Poppins',
              fontWeight: FontWeight.w200,
              textStyle: const TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  color: match.winningAlliance == AllianceColors.RED ? const Color.fromRGBO(255, 63, 63, 1) : const Color.fromRGBO(54, 98, 255, 1),
                  height: 250,
                  child: Image.asset("assets/images/background/shapes.png",
                      cacheHeight: 250)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              match.redAllianceTotalPoints.toString(),
                              style: GoogleFonts.getFont('Poppins',
                                  fontWeight: match.winningAlliance == AllianceColors.RED ? FontWeight.w600 : FontWeight.w300,
                                  fontSize: 36,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
                            ),
                            Text(
                              "RED",
                              style: GoogleFonts.getFont('Poppins',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "-",
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 36,
                              textStyle: const TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Row(children: [
                          Column(
                            children: [
                              Text(
                                match.blueAllianceTotalPoints.toString(),
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: match.winningAlliance == AllianceColors.BLUE ? FontWeight.w600 : FontWeight.w300,
                                    fontSize: 36,
                                    textStyle:
                                        const TextStyle(color: Colors.white)),
                              ),
                              Text(
                                "BLUE",
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    textStyle:
                                        const TextStyle(color: Colors.white)),
                              )
                            ],
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      match.winningAlliance == AllianceColors.BOTH ? "A TIE??" : ((match.winningAlliance == AllianceColors.RED ? "RED" : "BLUE") + " WON!"),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      "GOING OFF?!?",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      match.redAllianceTeams[0].teamNickname.toUpperCase() + " " + match.redAllianceTeams[0].teamNumber.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.redAllianceTeams[1].teamNickname.toUpperCase() + " " + match.redAllianceTeams[1].teamNumber.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "AUTON",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.redAllianceAutonPoints.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "TELEOP/ENDGAME",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      (match.redAllianceTotalPoints + match.redAllianceFouls - match.redAllianceAutonPoints).toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "FOULS",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.redAllianceFouls.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: TextStyle(
                              color: match.redAllianceFouls > 0 ? const Color.fromRGBO(255, 63, 63, 1) : Colors.white)),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      match.blueAllianceTeams[0].teamNickname.toUpperCase() + " " + match.blueAllianceTeams[0].teamNumber.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.blueAllianceTeams[1].teamNickname.toUpperCase() + " " + match.blueAllianceTeams[1].teamNumber.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "AUTON",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.blueAllianceAutonPoints.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "TELEOP/ENDGAME",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      (match.blueAllianceTotalPoints + match.blueAllianceFouls - match.blueAllianceAutonPoints).toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "FOULS",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                    Text(
                      match.blueAllianceFouls.toString(),
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          textStyle: TextStyle(color: match.blueAllianceFouls > 0 ? const Color.fromRGBO(255, 63, 63, 1) : Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
