import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/pages/discover.dart';
import 'package:ftc_scouting_app/pages/team_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      bottomNavigationBar: FluidNavBar(
        // (1)
        style: const FluidNavBarStyle(
            barBackgroundColor: Color.fromARGB(255, 20, 20, 20),
            iconBackgroundColor: Color.fromARGB(255, 58, 58, 58),
            iconSelectedForegroundColor: Color.fromRGBO(139, 255, 99, 1),
            iconUnselectedForegroundColor: Colors.white),
            animationFactor: 2,
            defaultIndex: 0,
        icons: [
          // (2)
          FluidNavBarIcon(icon: Icons.home), // (3)
          FluidNavBarIcon(icon: Icons.search),
          FluidNavBarIcon(icon: Icons.person)
        ],
        onChange: (n) {
          HapticFeedback.lightImpact();
          if (n == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscoverPage()),
            );
          } else if (n == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TeamProfilePage()),
            );
          }
        }, // (4)
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                              "5",
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
                          height: 150,
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
                                      "16236",
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
                                      "RED",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 63, 63, 1),
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
                                      "3",
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
                                        "MATCHES TILL US",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                      ),
                                    )
                                  ])),
                        )),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 32.0),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [

                        //         ],
                        //       ),
                        //       Row(
                        //         children: [

                        //         ],
                        //       ),
                        //       Row(
                        //         children: [

                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // )
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
                    Row(
                      children: [
                        Text(
                          "16236",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    MATCH 1",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    153 POINTS",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "   WIN    ",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(90, 255, 63, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                            ),
                            child: Text(
                              "VIEW MATCH",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(90, 255, 63, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9)),
                            ))
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(155, 155, 155, 0.49),
                    ),
                    Row(
                      children: [
                        Text(
                          "20399",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    MATCH 2",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    22 POINTS",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "   LOSS    ",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(255, 63, 63, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                            ),
                            child: Text(
                              "VIEW MATCH",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(90, 255, 63, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9)),
                            ))
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(155, 155, 155, 0.49),
                    ),
                    Row(
                      children: [
                        Text(
                          "10746",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    MATCH 3",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    142 POINTS",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "   WIN    ",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(90, 255, 63, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                            ),
                            child: Text(
                              "VIEW MATCH",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(90, 255, 63, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9)),
                            ))
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(155, 155, 155, 0.49),
                    ),
                    Row(
                      children: [
                        Text(
                          "19456",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    MATCH 4",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "    102 POINTS",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Text(
                          "   WIN    ",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(90, 255, 63, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.0)),
                              side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                            ),
                            child: Text(
                              "VIEW MATCH",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(90, 255, 63, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9)),
                            ))
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(155, 155, 155, 0.49),
                    )
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
