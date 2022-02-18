import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class TeamOverview extends StatefulWidget {
  final FTCTeam teamInfo;
  const TeamOverview(this.teamInfo, {Key? key}) : super(key: key);

  @override
  _TeamOverviewState createState() => _TeamOverviewState(teamInfo);
}

class _TeamOverviewState extends State<TeamOverview> {
  final FTCTeam teamInfo;
  _TeamOverviewState(this.teamInfo);

  var following = false;

  @override
  Widget build(BuildContext context) {
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
        title: teamInfo.logo != "" ? Image.network(
            teamInfo.logo,
            cacheWidth: 93) : Text(teamInfo.teamNickname + " " + teamInfo.teamNumber.toString()),
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
                      child: teamInfo.robotThumbnail != "" ? Image.network(
                        teamInfo.robotThumbnail,
                        cacheHeight: 213,
                      ) : Image.network(
                        "https://lh5.googleusercontent.com/LRoSg9m2BTWX2CDjRNexjROhjRt_vRsdsT73N5PcAfbWlidJ-XBNjUXnRUztR0krXpbau5e73JzAihw2HLG9pGZQw2Ol2pEd38c6VhK1je7wx_9EGjYlta8J1NZ-zFVm3MfkSBts7A",
                        cacheHeight: 213,
                      )),
                  Column(
                    children: [
                      const SizedBox(height: 130),
                      Row(
                        children: [
                          Text(
                            "MATCH 5 ALLIANCE PARTNER  ",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Color.fromRGBO(216, 216, 216, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11)),
                          ),
                          OutlinedButton(
                            onPressed: () => {
                              setState((() {
                                if (following) {
                                  following = false;
                                  teamInfo.following = false;
                                } else {
                                  following = true;
                                  teamInfo.following = true;
                                }
                                HapticFeedback.heavyImpact();
                              }))
                            },
                            child: Text(
                              !following ? "FOLLOW" : "FOLLOWING",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: TextStyle(
                                      color: !following
                                          ? const Color.fromRGBO(255, 92, 0, 1)
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              backgroundColor: !following
                                  ? Colors.black
                                  : const Color.fromRGBO(255, 92, 0, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(255, 92, 0, 1)),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: null,
                            child: Text(
                              "CONTACT",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(255, 92, 0, 1),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(255, 92, 0, 1)),
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
                            const Icon(Icons.arrow_drop_up,
                                color: Color.fromRGBO(90, 255, 63, 1),
                                size: 50.0),
                            Column(
                              children: [
                                Text(
                                  "#1",
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
                                  "OUT OF 40",
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
                                      "3",
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
                                      "1",
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
                                      "153",
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
              Card(
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
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Can be annoying",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Is vroom vroom",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
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
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Cannot hang",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Cannot drop team marker",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Cannot do anything",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                  ]),
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
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Frieght Deposit (SH)/Barcode Detection",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Duck Carousel",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Warehouse Parking",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Storage Unit Parking",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Frieght Storage Unit Deposit",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                  ]),
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
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Shared Shipping Hub",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Alliance Shipping Hub - Level 1",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Storage Unit",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Alliance Shipping Hub - Level 2",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Alliance Shipping Hub - Level 3",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                  ]),
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
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Deliver Duck",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Balanced Alliance Shipping Hub",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check,
                            color: Color.fromRGBO(90, 255, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Unbalanced Shared Shipping Hub",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Parking in Warehouse",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close,
                            color: Color.fromRGBO(255, 63, 63, 1)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Capping",
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13))),
                      ],
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
