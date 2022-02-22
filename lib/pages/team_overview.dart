import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:ftc_scouting_app/classes/teamStats.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamOverview extends StatefulWidget {
  final FTCTeam teamInfo;
  final Map<int, FTCTeam> teamAlliances;
  const TeamOverview(this.teamInfo, this.teamAlliances, {Key? key})
      : super(key: key);

  @override
  _TeamOverviewState createState() =>
      _TeamOverviewState(teamInfo, teamAlliances);
}

class _TeamOverviewState extends State<TeamOverview> {
  final FTCTeam teamInfo;
  final Map<int, FTCTeam> teamAlliances;
  _TeamOverviewState(this.teamInfo, this.teamAlliances);

  var following = false;
  // var sumNum = (1 << 1) |
  //     (1 << 2) |
  //     (1 << 3) |
  //     (1 << 11) |
  //     (1 << 12) |
  //     (1 << 13) |
  //     (1 << 14) |
  //     (1 << 15) |
  //     (1 << 21) |
  //     (1 << 22) |
  //     (1 << 23);

  // SKILLS HASH DECODING CHART
  // --------------------------
  // BIT  |  CATEGORY  | SKILL
  // -----|------------|-------
  //   1  |   AUTON    | Frieght Deposit (SH)/Barcode Detection
  //   2  |   AUTON    | Duck Carousel
  //   3  |   AUTON    | Warehouse Parking
  //   4  |   AUTON    | Storage Unit Parking
  //   5  |   AUTON    | Freight Storage Unit Deposit
  //   6  |   AUTON    | Reserved
  //   7  |   AUTON    | Reserved
  //   8  |   AUTON    | Reserved
  //   9  |   AUTON    | Reserved
  //  10  |   AUTON    | Reserved
  //  11  |   DRIVER   | Shared Shipping Hub
  //  12  |   DRIVER   | Alliance Shipping Hub - Level 1
  //  13  |   DRIVER   | Alliance Shipping Hub - Level 2
  //  14  |   DRIVER   | Alliance Shipping Hub - Level 3
  //  15  |   DRIVER   | Storage Unit
  //  16  |   DRIVER   | Reserved
  //  17  |   DRIVER   | Reserved
  //  18  |   DRIVER   | Reserved
  //  19  |   DRIVER   | Reserved
  //  20  |   DRIVER   | Reserved
  //  21  |   ENDGAME  | Deliver Duck
  //  22  |   ENDGAME  | Balanced Alliance Shipping Hub
  //  23  |   ENDGAME  | Leaning Shared Shipping Hub
  //  24  |   ENDGAME  | Parking in Warehouse
  //  25  |   ENDGAME  | Capping (no cap)
  //  26  |   ENDGAME  | Reserved
  //  27  |   ENDGAME  | Reserved
  //  28  |   ENDGAME  | Reserved
  //  29  |   ENDGAME  | Reserved
  //  30  |   ENDGAME  | Reserved
  //  31  |    META    | Reserved
  //  32  |    META    | Reserved

  List<List<String>> decodeMissionSkills(n) {
    var i = 0; // Decoding 32-bit "hashed" number of skills
    List<String> autonCan = [];
    List<String> autonCannot = [];
    List<String> driverCan = [];
    List<String> driverCannot = [];
    List<String> endgameCan = [];
    List<String> endgameCannot = [];

    Map<int, String> bitToString = {
      1: "Frieght Deposit (SH)/Barcode Detection",
      2: "Duck Carousel",
      3: "Warehouse Parking",
      4: "Storage Unit Parking",
      5: "Freight Storage Unit Deposit",
      11: "Shared Shipping Hub",
      12: "Alliance Shipping Hub - Level 1",
      13: "Alliance Shipping Hub - Level 2",
      14: "Alliance Shipping Hub - Level 3",
      15: "Storage Unit",
      21: "Deliver Duck",
      22: "Balanced Alliance Shipping Hub",
      23: "Leaning Shared Shipping Hub",
      24: "Parking in Warehouse",
      25: "Capping",
    };
    const reservedBits = [
      6,
      7,
      8,
      9,
      10,
      16,
      17,
      18,
      19,
      20,
      26,
      27,
      28,
      29,
      30
    ];

    while (i < 32) {
      if (reservedBits.where((element) => element == i).toList().isEmpty &&
          i != 0) {
        var x = n & 0x1; // Bitwise AND operation
        if (x == 1) {
          // if bit == 1, can do, else cannot
          if (i <= 10) {
            autonCan.add(bitToString[i] ?? "NULL");
          } else if (i <= 20) {
            driverCan.add(bitToString[i] ?? "NULL");
          } else if (i <= 30) {
            endgameCan.add(bitToString[i] ?? "NULL");
          }
        } else {
          if (i <= 10) {
            autonCannot.add(bitToString[i] ?? "NULL");
          } else if (i <= 20) {
            driverCannot.add(bitToString[i] ?? "NULL");
          } else if (i <= 30) {
            endgameCannot.add(bitToString[i] ?? "NULL");
          }
        }
      }
      n = n >> 1; //right shift og number
      i++; // Rinse. Repeat
    }

    return [
      autonCan,
      autonCannot,
      driverCan,
      driverCannot,
      endgameCan,
      endgameCannot
    ];
  }

  String allianceMatchString = "LOADING...";

  @override
  Widget build(BuildContext context) {
    allianceMatchString = teamAlliances.containsValue(teamInfo)
        ? ("MATCH " +
            teamAlliances.keys
                .firstWhere((element) =>
                    teamAlliances[element]!.teamNumber == teamInfo.teamNumber)
                .toString() +
            " ALLIANCE PARTNER  ")
        : "NEVER ALLIANCE PARTNER  ";
    var skills = teamInfo.isUser
        ? decodeMissionSkills(teamInfo.abilities)
        : [[], [], [], [], [], []];
    int _ratingLevel = 5;
    if (teamInfo.teamMatch >= 0 && teamInfo.teamMatch < 20) {
      _ratingLevel = 1;
    } else if (teamInfo.teamMatch >= 20 && teamInfo.teamMatch < 40) {
      _ratingLevel = 2;
    } else if (teamInfo.teamMatch >= 40 && teamInfo.teamMatch < 60) {
      _ratingLevel = 3;
    } else if (teamInfo.teamMatch >= 60 && teamInfo.teamMatch < 80) {
      _ratingLevel = 4;
    } else if (teamInfo.teamMatch >= 80 && teamInfo.teamMatch <= 100) {
      _ratingLevel = 5;
    }

    following = teamInfo.following;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Wrap(
                      children: const [
                        ListTile(
                          tileColor: Color.fromRGBO(29, 29, 29, 1),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          leading: Icon(Icons.share),
                          title: Text('Share'),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(29, 29, 29, 1),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          leading: Icon(Icons.request_quote_outlined),
                          title: Text('Request Alliance Brief'),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(29, 29, 29, 1),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          leading: Icon(Icons.assistant_photo_outlined),
                          title: Text('Report'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
        centerTitle: true,
        title: teamInfo.logo != ""
            ? Image.network(teamInfo.logo, cacheWidth: 93)
            : Text(
                teamInfo.teamNickname + " " + teamInfo.teamNumber.toString(),
                overflow: TextOverflow.fade,
                style: GoogleFonts.getFont('Poppins',
                    fontWeight: FontWeight.w200,
                    textStyle: const TextStyle(color: Colors.white)),
              ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Stack(
                children: [
                  ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.8), BlendMode.dstATop),
                      child: teamInfo.robotThumbnail != ""
                          ? Image.network(
                              teamInfo.robotThumbnail,
                              cacheHeight: 213,
                            )
                          : Image.network(
                              "https://lh5.googleusercontent.com/LRoSg9m2BTWX2CDjRNexjROhjRt_vRsdsT73N5PcAfbWlidJ-XBNjUXnRUztR0krXpbau5e73JzAihw2HLG9pGZQw2Ol2pEd38c6VhK1je7wx_9EGjYlta8J1NZ-zFVm3MfkSBts7A",
                              cacheHeight: 213,
                            )),
                  Column(
                    children: [
                      const SizedBox(height: 130),
                      Row(
                        children: [
                          Text(
                            allianceMatchString, //"MATCH 5 ALLIANCE PARTNER  ",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Color.fromRGBO(216, 216, 216, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11)),
                          ),
                          teamInfo.isUser
                              ? OutlinedButton(
                                  onPressed: () async {
                                    var prefs =
                                        await SharedPreferences.getInstance();
                                    setState((() {
                                      if (following) {
                                        following = false;
                                        teamInfo.following = false;
                                        prefs.setBool(
                                            "following-" +
                                                teamInfo.teamNumber.toString(),
                                            false);
                                      } else {
                                        following = true;
                                        teamInfo.following = true;
                                        prefs.setBool(
                                            "following-" +
                                                teamInfo.teamNumber.toString(),
                                            true);
                                      }
                                      HapticFeedback.heavyImpact();
                                    }));
                                  },
                                  child: Text(
                                    !following ? "FOLLOW" : "FOLLOWING",
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: TextStyle(
                                            color: !following
                                                ? teamInfo.theme
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor: !following
                                        ? Colors.black
                                        : teamInfo.theme,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(34.0)),
                                    side: BorderSide(
                                        width: 2.0, color: teamInfo.theme),
                                  ),
                                )
                              : const Text(""),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: null,
                            child: Text(
                              teamInfo.isUser ? "CONTACT" : "INVITE TO OPTIMUM",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: TextStyle(
                                      color: teamInfo.theme,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side:
                                  BorderSide(width: 2.0, color: teamInfo.theme),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Card(
                color: const Color.fromRGBO(29, 29, 29, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "ALLIANCE MATCH RATING",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            teamInfo.teamMatch.toString().split(".")[0] + "%",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30)),
                          )
                        ],
                      ),
                      Container(
                        height: 75,
                        padding: EdgeInsets.zero,
                        child: RiveAnimation.asset(
                          "assets/rive/scouter_rating_bar" +
                              _ratingLevel.toString() +
                              ".riv",
                          stateMachines: const ["main"],
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          antialiasing: true,
                          artboard: "Rating Bar",
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
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
                            teamInfo.stats.trend == TeamStatsTrend.UP
                                ? const Icon(Icons.arrow_drop_up,
                                    color: Color.fromRGBO(90, 255, 63, 1),
                                    size: 50.0)
                                : (teamInfo.stats.trend == TeamStatsTrend.DOWN
                                    ? const Icon(Icons.arrow_drop_down,
                                        color: Color.fromRGBO(255, 63, 63, 1),
                                        size: 50.0)
                                    : const SizedBox(
                                        width: 50,
                                      )),
                            Column(
                              children: [
                                Text(
                                  "#" + teamInfo.stats.rank.toString(),
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
                                      teamInfo.stats.totalTeams.toString(),
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
                                  scrollDirection: Axis.vertical,
                                  childAspectRatio: 2,
                                  children: <Widget>[
                                    Text(
                                      teamInfo.stats.wins.toString(),
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
                                      teamInfo.stats.losses.toString(),
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
                                      teamInfo.stats.highScore.toString(),
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
                                )
                                // Row(children: [
                                //                             Column(
                                //                               children: [

                                //                               ],
                                //                             ),
                                //                             Column(
                                //                               children: [

                                //                               ],
                                //                             )
                                //                           ]),
                                ),
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     Row(children: [
                        //       Column(
                        //         children: const [Text("1"), Text("3")],
                        //       ),
                        //       Column(
                        //         children: const [
                        //           Text("MATCHES LEFT"),
                        //           Text("MACTHES TILL US"),
                        //         ],
                        //       )
                        //     ])
                        //   ],
                        // )
                      ],
                    )
                  ]),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              teamInfo.isUser
                  ? Card(
                      color: const Color.fromRGBO(29, 29, 29, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_objects_outlined,
                                color: Colors.white,
                              ),
                              Text("  STRENGTHS",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13))),
                            ],
                          ),
                          for (var strength in teamInfo.teamStrengths)
                            (Row(
                              children: [
                                const Icon(Icons.check,
                                    color: Color.fromRGBO(90, 255, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(strength,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                          const SizedBox(
                            height: 22,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.bug_report,
                                color: Colors.white,
                              ),
                              Text("  WEAKNESSES",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13))),
                            ],
                          ),
                          for (var weakness in teamInfo.teamWeaknesses)
                            (Row(
                              children: [
                                const Icon(Icons.close,
                                    color: Color.fromRGBO(255, 63, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(weakness,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                        ]),
                      ),
                    )
                  : Text(""),
              teamInfo.isUser
                  ? const SizedBox(
                      height: 22,
                    )
                  : Text(""),
              teamInfo.isUser
                  ? Card(
                      color: const Color.fromRGBO(29, 29, 29, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bolt_outlined,
                                color: Colors.white,
                              ),
                              Text("  AUTONOMOUS",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13))),
                            ],
                          ),
                          for (var strength in skills[0])
                            (Row(
                              children: [
                                const Icon(Icons.check,
                                    color: Color.fromRGBO(90, 255, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(strength,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                          for (var weakness in skills[1])
                            (Row(
                              children: [
                                const Icon(Icons.close,
                                    color: Color.fromRGBO(255, 63, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(weakness,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                        ]),
                      ),
                    )
                  : Text(""),
              teamInfo.isUser
                  ? const SizedBox(
                      height: 22,
                    )
                  : Text(""),
              teamInfo.isUser
                  ? Card(
                      color: const Color.fromRGBO(29, 29, 29, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.gamepad_outlined,
                                color: Colors.white,
                              ),
                              Text("  DRIVER-CONTROLLED",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13))),
                            ],
                          ),
                          for (var strength in skills[2])
                            (Row(
                              children: [
                                const Icon(Icons.check,
                                    color: Color.fromRGBO(90, 255, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(strength,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                          for (var weakness in skills[3])
                            (Row(
                              children: [
                                const Icon(Icons.close,
                                    color: Color.fromRGBO(255, 63, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(weakness,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                        ]),
                      ),
                    )
                  : Text(""),
              teamInfo.isUser
                  ? const SizedBox(
                      height: 22,
                    )
                  : Text(""),
              teamInfo.isUser
                  ? Card(
                      color: const Color.fromRGBO(29, 29, 29, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              Text("  END GAME",
                                  style: GoogleFonts.getFont("Poppins",
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13))),
                            ],
                          ),
                          for (var strength in skills[4])
                            (Row(
                              children: [
                                const Icon(Icons.check,
                                    color: Color.fromRGBO(90, 255, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(strength,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                          for (var weakness in skills[5])
                            (Row(
                              children: [
                                const Icon(Icons.close,
                                    color: Color.fromRGBO(255, 63, 63, 1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(weakness,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ],
                            )),
                        ]),
                      ),
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }
}
