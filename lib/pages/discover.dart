import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/classes/team.dart';
import 'package:ftc_scouting_app/pages/team_overview.dart';
import 'package:ftc_scouting_app/pages/team_profile.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'homepage.dart';

class DiscoverPage extends StatefulWidget {
  final DatabaseService dbService;
  const DiscoverPage(this.dbService, {Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState(dbService);
}

class _DiscoverPageState extends State<DiscoverPage> {
  final DatabaseService dbService;
  // List<FTCTeam> teams = [
  //   FTCTeam(
  //       "Joos",
  //       16236,
  //       98,
  //       "this is some boilerplate description, we basicly cant do anything and cant speel",
  //       ["Frieght Deposit (SH)/Barcode Detection", "Warehouse Parking"],
  //       ["Cannot do anything"],
  //       true,
  //       following: true,
  //       logo:
  //           "https://cdn.discordapp.com/icons/871829127227928616/8f641588fe6d07981d8d02d635323517.webp",
  //       robotThumbnail:
  //           "https://lh5.googleusercontent.com/LRoSg9m2BTWX2CDjRNexjROhjRt_vRsdsT73N5PcAfbWlidJ-XBNjUXnRUztR0krXpbau5e73JzAihw2HLG9pGZQw2Ol2pEd38c6VhK1je7wx_9EGjYlta8J1NZ-zFVm3MfkSBts7A"),
  //   FTCTeam(
  //     "MBET",
  //     10223,
  //     48,
  //     "this is some boilerplate description, we basicly cant do anything and cant speel",
  //     ["Frieght Deposit (SH)/Barcode Detection", "Warehouse Parking"],
  //     ["Cannot do anything"],
  //     false,
  //   ),
  //   FTCTeam(
  //     "Tbinkers",
  //     21334,
  //     8,
  //     "this is some boilerplate description, we basicly cant do anything and cant speel",
  //     ["Frieght Deposit (SH)/Barcode Detection", "Warehouse Parking"],
  //     ["Cannot do anything"],
  //     false,
  //   ),
  //   FTCTeam(
  //     "Bruhaps",
  //     12237,
  //     24,
  //     "this is some boilerplate description, we basicly cant do anything and cant speel",
  //     ["Frieght Deposit (SH)/Barcode Detection", "Warehouse Parking"],
  //     ["Cannot do anything"],
  //     false,
  //   ),
  // ];
  List<FTCTeam> teams = [
    // FTCTeam(
    //   "Bruhaps",
    //   12237,
    //   24,
    //   "this is some boilerplate description, we basicly cant do anything and cant speel",
    //   ["Frieght Deposit (SH)/Barcode Detection", "Warehouse Parking"],
    //   ["Cannot do anything"],
    //   false,
    // ),
  ];
  bool gotInfo = false;
  _DiscoverPageState(this.dbService);

  @override
  Widget build(BuildContext context) {
    if (!gotInfo) {
      dbService.getCompTeams().then((teamsData) {
        setState(() {
          teams = teamsData;
          gotInfo = true;
        });
      });
    }

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
        defaultIndex: 1,
        icons: [
          // (2)
          FluidNavBarIcon(icon: Icons.home), // (3)
          FluidNavBarIcon(icon: Icons.search),
          FluidNavBarIcon(icon: Icons.person)
        ],
        onChange: (n) {
          HapticFeedback.lightImpact();
          if (n == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(dbService)),
            );
          } else if (n == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeamProfilePage(dbService)),
            );
          }
        }, // (4)
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    "DISCOVER",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.getFont('Poppins',
                        fontWeight: FontWeight.w200,
                        textStyle:
                            const TextStyle(fontSize: 35, color: Colors.white)),
                  ),
                  Container(
                    color: Colors.black,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 22),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeamOverview(teams[index], dbService.userAlliancePartners)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                                color: const Color.fromRGBO(29, 29, 29, 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: teams[index].logo != ""
                                                ? 200
                                                : 300,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                teams[index]
                                                        .teamNickname
                                                        .toUpperCase() +
                                                    " " +
                                                    teams[index]
                                                        .teamNumber
                                                        .toString(),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    textStyle: const TextStyle(
                                                        fontSize: 24,
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          teams[index].logo != ""
                                              ? Image.network(teams[index].logo,
                                                  cacheHeight: 53)
                                              : const Text("")
                                        ],
                                      ),
                                      Text(
                                        teams[index]
                                                .teamMatch
                                                .toString()
                                                .split(".")[0] +
                                            "% ALLIANCE MATCH",
                                        style: GoogleFonts.getFont('Poppins',
                                            fontWeight: FontWeight.w700,
                                            textStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white)),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: teams[index].teamHeadliner,
                                            style: GoogleFonts.getFont(
                                                'Poppins',
                                                fontWeight: FontWeight.w400,
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        172, 172, 172, 1))),
                                            children: [
                                              TextSpan(
                                                  text: " View Overview >",
                                                  style: GoogleFonts.getFont(
                                                      'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      )))
                                            ]),
                                      ),
                                      teams[index].isUser ? SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.check,
                                                    color: Color.fromRGBO(
                                                        90, 255, 63, 1)),
                                                const SizedBox(
                                                  width: 2.5,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                      teams[index]
                                                          .teamStrengths[0],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      11))),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.check,
                                                    color: Color.fromRGBO(
                                                        90, 255, 63, 1)),
                                                const SizedBox(
                                                  width: 2.5,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                      teams[index]
                                                          .teamStrengths[1],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      11))),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.close,
                                                    color: Color.fromRGBO(
                                                        255, 63, 63, 1)),
                                                const SizedBox(
                                                  width: 2.5,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                      teams[
                                                              index]
                                                          .teamWeaknesses[0],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      11))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ) : const Text("")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 11),
                    child: const Center(
                      child: Text(
                        "if u havent found smth yet, u aint gonna find it",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white30, fontSize: 11),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 100,
                child: FloatingSearchBar(
                  hint: 'Search for teams...',
                  scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionCurve: Curves.easeInOut,
                  physics: const BouncingScrollPhysics(),
                  axisAlignment: 0.0, // : -1.0,
                  elevation: 10,
                  openAxisAlignment: 0.0,
                  width: 600, // : 500,
                  debounceDelay: const Duration(milliseconds: 500),
                  backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                  iconColor: Colors.white,
                  accentColor: Colors.white,
                  automaticallyImplyBackButton: false,
                  onQueryChanged: (query) {
                    // Call your model, bloc, controller here.
                  },
                  // Specify a custom transition to be used for
                  // animating between opened and closed stated.
                  transition: CircularFloatingSearchBarTransition(),
                  actions: [
                    FloatingSearchBarAction(
                      showIfOpened: false,
                      child: CircularButton(
                        icon: const Icon(Icons.accessibility_new_outlined),
                        onPressed: () {},
                      ),
                    ),
                    FloatingSearchBarAction.searchToClear(
                      showIfClosed: false,
                    ),
                  ],
                  hintStyle: const TextStyle(color: Colors.white30),
                  queryStyle: const TextStyle(color: Colors.white),
                  backdropColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  builder: (context, transition) {
                    return const Text("");
                    // return ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: Material(
                    //     color: Color.fromARGB(255, 255, 255, 255),
                    //     elevation: 4.0,
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: Colors.accents.map((color) {
                    //         return Container(height: 112, color: color);
                    //       }).toList(),
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       const SizedBox(width: 20,),
              //       ElevatedButton(
              //         onPressed: null,
              //         child: const Text("Sort by best match",
              //             style: TextStyle(
              //               color: Colors.white,
              //             )),
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color>(
              //               const Color.fromRGBO(29, 29, 29, 1)),
              //               elevation: MaterialStateProperty.all<double>(10),
              //         ),
              //       ),
              //       const SizedBox(width: 20,),
              //       ElevatedButton(
              //         onPressed: null,
              //         child: const Text("Sunnyvale QT",
              //             style: TextStyle(
              //               color: Colors.white,
              //             )),
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color>(
              //               const Color.fromRGBO(29, 29, 29, 1)),
              //         ),
              //       ),
              //       const SizedBox(width: 20,),
              //       ElevatedButton(onPressed: null, child: const Text("Local to you",
              //             style: TextStyle(
              //               color: Colors.white,
              //             )),
              //       style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color>(
              //               const Color.fromRGBO(29, 29, 29, 1)),
              //         ),),

              //     ],
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
