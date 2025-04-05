import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ftc_scouting_app/pages/homepage.dart';
import 'package:ftc_scouting_app/pages/discover.dart';
import 'package:ftc_scouting_app/pages/settings/about_app.dart';
import 'package:ftc_scouting_app/pages/settings/general.dart';
import 'package:ftc_scouting_app/pages/settings/legal.dart';
import 'package:ftc_scouting_app/pages/settings/robot.dart';
import 'package:ftc_scouting_app/pages/settings/team_qualities.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamProfilePage extends StatefulWidget {
  final DatabaseService dbService;
  const TeamProfilePage(this.dbService, {Key? key}) : super(key: key);

  @override
  _TeamProfilePageState createState() => _TeamProfilePageState(dbService);
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  final DatabaseService dbService;

  _TeamProfilePageState(this.dbService);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: FluidNavBar(
        // (1)
        style: const FluidNavBarStyle(
            barBackgroundColor: Color.fromARGB(255, 20, 20, 20),
            iconBackgroundColor: Color.fromARGB(255, 58, 58, 58),
            iconSelectedForegroundColor: Color.fromRGBO(139, 255, 99, 1),
            iconUnselectedForegroundColor: Colors.white),
        animationFactor: 2,
        defaultIndex: 2,
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
              MaterialPageRoute(builder: (context) => DiscoverPage(dbService)),
            );
          } else if (n == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(dbService)),
            );
          }
        }, // (4)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "TEAM PROFILE",
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w200,
                      textStyle:
                          const TextStyle(fontSize: 35, color: Colors.white)),
                ),
                const SizedBox(
                  height: 24,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                  ),
                  color: const Color.fromRGBO(29, 29, 29, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GeneralSettingsPage(dbService)),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                      "assets/images/icons/general.svg"),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "General",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Team Logo · Team Nickname",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.white30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 65, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(155, 155, 155, 0.5),
                                  width: 1.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeamQualitiesSettingsPage(dbService)),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                      "assets/images/icons/qualities.svg"),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Team Qualities",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Team Strengths · Team Weaknesses",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11.5,
                                          color: Colors.white30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 65, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(155, 155, 155, 0.5),
                                  width: 1.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RobotSettingsPage(dbService)),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                      "assets/images/icons/robot.svg"),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Robot",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Robot Thumbnail · Robot CAD",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.white30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(19.0),
                //   ),
                //   color: const Color.fromRGBO(29, 29, 29, 1),
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 16.0, top: 16.0, bottom: 16.0),
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(right: 16.0),
                //           child: Row(
                //             children: [
                //               SizedBox(
                //                 width: 32,
                //                 height: 32,
                //                 child: SvgPicture.asset(
                //                     "assets/images/icons/following.svg"),
                //               ),
                //               const SizedBox(
                //                 width: 35,
                //               ),
                //               Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Following",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w600,
                //                         fontSize: 20,
                //                         color: Colors.white),
                //                   ),
                //                   Text(
                //                     "Teams · Team Unfollow",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w400,
                //                         fontSize: 12,
                //                         color: Colors.white30),
                //                   ),
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //         Container(
                //           margin: const EdgeInsets.only(
                //               left: 65, bottom: 10, top: 10),
                //           decoration: const BoxDecoration(
                //             border: Border(
                //               bottom: BorderSide(
                //                   color: Color.fromRGBO(155, 155, 155, 0.5),
                //                   width: 1.0),
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(right: 16.0),
                //           child: Row(
                //             children: [
                //               SizedBox(
                //                 width: 32,
                //                 height: 32,
                //                 child: SvgPicture.asset(
                //                     "assets/images/icons/followers.svg"),
                //               ),
                //               const SizedBox(
                //                 width: 35,
                //               ),
                //               Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Followers",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w600,
                //                         fontSize: 20,
                //                         color: Colors.white),
                //                   ),
                //                   Text(
                //                     "Teams · Block Teams · Report Teams",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w400,
                //                         fontSize: 11.75,
                //                         color: Colors.white30),
                //                   ),
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //         Container(
                //           margin: const EdgeInsets.only(
                //               left: 65, bottom: 10, top: 10),
                //           decoration: const BoxDecoration(
                //             border: Border(
                //               bottom: BorderSide(
                //                   color: Color.fromRGBO(155, 155, 155, 0.5),
                //                   width: 1.0),
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(right: 16.0),
                //           child: Row(
                //             children: [
                //               SizedBox(
                //                 width: 32,
                //                 height: 32,
                //                 child: SvgPicture.asset(
                //                     "assets/images/icons/visibility.svg"),
                //               ),
                //               const SizedBox(
                //                 width: 35,
                //               ),
                //               Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Visibility",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w600,
                //                         fontSize: 20,
                //                         color: Colors.white),
                //                   ),
                //                   Text(
                //                     "Change Visibility",
                //                     style: GoogleFonts.getFont("Poppins",
                //                         fontWeight: FontWeight.w400,
                //                         fontSize: 12,
                //                         color: Colors.white30),
                //                   ),
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                  ),
                  color: const Color.fromRGBO(29, 29, 29, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 16.0),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 16.0),
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         width: 32,
                        //         height: 32,
                        //         child: SvgPicture.asset(
                        //             "assets/images/icons/app_settings.svg"),
                        //       ),
                        //       const SizedBox(
                        //         width: 35,
                        //       ),
                        //       Column(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "App Settings",
                        //             style: GoogleFonts.getFont("Poppins",
                        //                 fontWeight: FontWeight.w600,
                        //                 fontSize: 20,
                        //                 color: Colors.white),
                        //           ),
                        //           Text(
                        //             "Accessibility · Display · Animations",
                        //             style: GoogleFonts.getFont("Poppins",
                        //                 fontWeight: FontWeight.w400,
                        //                 fontSize: 12,
                        //                 color: Colors.white30),
                        //           ),
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       left: 65, bottom: 10, top: 10),
                        //   decoration: const BoxDecoration(
                        //     border: Border(
                        //       bottom: BorderSide(
                        //           color: Color.fromRGBO(155, 155, 155, 0.5),
                        //           width: 1.0),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AppLegalPage(dbService)),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                      "assets/images/icons/legal.svg"),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Legal",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Privacy · Terms of Use",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.white30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 65, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(155, 155, 155, 0.5),
                                  width: 1.0),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AboutAppPage(dbService)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                      "assets/images/icons/about_app.svg"),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About App",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Juice 16236 · Licenses",
                                      style: GoogleFonts.getFont("Poppins",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.white30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    );
  }
}
