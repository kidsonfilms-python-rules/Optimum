import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/classes/abilities.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamQualitiesSettingsPage extends StatefulWidget {
  final DatabaseService databaseService;
  const TeamQualitiesSettingsPage(this.databaseService, {Key? key})
      : super(key: key);

  @override
  _TeamQualitiesSettingsPageState createState() =>
      _TeamQualitiesSettingsPageState(databaseService);
}

class _TeamQualitiesSettingsPageState extends State<TeamQualitiesSettingsPage> {
  final DatabaseService databaseService;
  _TeamQualitiesSettingsPageState(this.databaseService);

  final strengthControllor = TextEditingController();
  final weaknessesControllor = TextEditingController();

  List<List<dynamic>> decodeMissionSkills(n) {
    var i = 0; // Decoding 32-bit "hashed" number of skills
    List<String> autonCan = [];
    List<String> autonCannot = [];
    List<String> driverCan = [];
    List<String> driverCannot = [];
    List<String> endgameCan = [];
    List<String> endgameCannot = [];
    List<Ability> _allAbilities = [];

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
            _allAbilities.add(Ability(bitToString[i]!, "Auton", false, true));
          } else if (i <= 20) {
            driverCan.add(bitToString[i] ?? "NULL");
            _allAbilities.add(
                Ability(bitToString[i]!, "Driver Controlled", false, true));
          } else if (i <= 30) {
            endgameCan.add(bitToString[i] ?? "NULL");
            _allAbilities.add(Ability(bitToString[i]!, "Endgame", false, true));
          }
        } else {
          if (i <= 10) {
            autonCannot.add(bitToString[i] ?? "NULL");
            _allAbilities.add(Ability(bitToString[i]!, "Auton", false, false));
          } else if (i <= 20) {
            driverCannot.add(bitToString[i] ?? "NULL");
            _allAbilities.add(
                Ability(bitToString[i]!, "Driver Controlled", false, false));
          } else if (i <= 30) {
            endgameCannot.add(bitToString[i] ?? "NULL");
            _allAbilities
                .add(Ability(bitToString[i]!, "Endgame", false, false));
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
      endgameCannot,
      _allAbilities
    ];
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    weaknessesControllor.dispose();
    strengthControllor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> _teamStrengths = databaseService.compTeams
        .where((team) => team.teamNumber == databaseService.userTeamNumber)
        .toList()[0]
        .teamStrengths;
    List<dynamic> _teamWeaknesses = databaseService.compTeams
        .where((team) => team.teamNumber == databaseService.userTeamNumber)
        .toList()[0]
        .teamWeaknesses;

    var skills = decodeMissionSkills(databaseService.compTeams
        .where((team) => team.teamNumber == databaseService.userTeamNumber)
        .toList()[0]
        .abilities);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "TEAM QUALITIES",
          style: GoogleFonts.getFont('Poppins',
              fontWeight: FontWeight.w200,
              textStyle: const TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Image.network(
                    //   databaseService.compTeams
                    //       .where((team) =>
                    //           team.teamNumber == databaseService.userTeamNumber)
                    //       .toList()[0]
                    //       .logo,
                    //   cacheHeight: 80,
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var strength in _teamStrengths)
                          Text(
                            strength,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.w200,
                                textStyle:
                                    const TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setStateBottomSheet) {
                                return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 20.0,
                                          sigmaY: 20.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "ADD STRENGTH",
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        strengthControllor,
                                                    onSubmitted: (input) {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      if (!_teamStrengths
                                                              .contains(
                                                                  input) &&
                                                          input != "") {
                                                        setState(() {
                                                          _teamStrengths
                                                              .add(input);
                                                        });
                                                      }
                                                      strengthControllor.text =
                                                          "";
                                                    },
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  for (var strength
                                                      in _teamStrengths)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(103,
                                                              105, 240, 175),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .greenAccent)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            strength,
                                                            style: GoogleFonts.getFont(
                                                                'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                              onPressed: () {
                                                                HapticFeedback
                                                                    .heavyImpact();
                                                                setState(() {
                                                                  setStateBottomSheet(
                                                                      () {
                                                                    _teamStrengths
                                                                        .remove(
                                                                            strength);
                                                                  });
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close))
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  OutlinedButton(
                                                    child: Text(
                                                      "SAVE",
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          90,
                                                                          255,
                                                                          63,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      if (Uri.parse(
                                                              strengthControllor
                                                                  .text)
                                                          .isAbsolute) {
                                                        setState(() {
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]
                                                              .teamStrengths = _teamStrengths;
                                                              databaseService.updateTeam(
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]);
                                                        });
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          34.0)),
                                                      side: const BorderSide(
                                                          width: 2.0,
                                                          color: Color.fromRGBO(
                                                              90, 255, 63, 1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              });
                            });
                      },
                      child: Text("CHANGE >",
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white30)),
                    )
                  ],
                ),
                Text("TEAM STRENGTHS",
                    style: GoogleFonts.getFont("Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white30)),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(155, 155, 155, 0.5),
                          width: 1.0),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Image.network(
                    //   databaseService.compTeams
                    //       .where((team) =>
                    //           team.teamNumber == databaseService.userTeamNumber)
                    //       .toList()[0]
                    //       .logo,
                    //   cacheHeight: 80,
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var strength in _teamWeaknesses)
                          Text(
                            strength,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.w200,
                                textStyle:
                                    const TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setStateBottomSheet) {
                                return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 20.0,
                                          sigmaY: 20.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "ADD WEAKNESS",
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        weaknessesControllor,
                                                    onSubmitted: (input) {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      if (!_teamWeaknesses
                                                              .contains(
                                                                  input) &&
                                                          input != "") {
                                                        setState(() {
                                                          _teamWeaknesses
                                                              .add(input);
                                                        });
                                                      }
                                                      weaknessesControllor
                                                          .text = "";
                                                    },
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  for (var weakness
                                                      in _teamWeaknesses)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              101, 255, 82, 82),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .redAccent)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            weakness,
                                                            style: GoogleFonts.getFont(
                                                                'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                              onPressed: () {
                                                                HapticFeedback
                                                                    .heavyImpact();
                                                                setState(() {
                                                                  setStateBottomSheet(
                                                                      () {
                                                                    _teamWeaknesses
                                                                        .remove(
                                                                            weakness);
                                                                  });
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close))
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  OutlinedButton(
                                                    child: Text(
                                                      "SAVE",
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          90,
                                                                          255,
                                                                          63,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      if (Uri.parse(
                                                              strengthControllor
                                                                  .text)
                                                          .isAbsolute) {
                                                        setState(() {
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]
                                                              .teamWeaknesses = _teamWeaknesses;
                                                              databaseService.updateTeam(
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]);
                                                        });
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          34.0)),
                                                      side: const BorderSide(
                                                          width: 2.0,
                                                          color: Color.fromRGBO(
                                                              90, 255, 63, 1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              });
                            });
                      },
                      child: Text("CHANGE >",
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white30)),
                    )
                  ],
                ),
                Text("TEAM WEAKNESSES",
                    style: GoogleFonts.getFont("Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white30)),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(155, 155, 155, 0.5),
                          width: 1.0),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var strength in skills[0])
                          Row(
                            children: [
                              const Icon(Icons.check,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                        for (var strength in skills[1])
                          Row(
                            children: [
                              const Icon(Icons.close,
                                  color: Color.fromRGBO(255, 63, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setStateBottomSheet) {
                                return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 20.0,
                                          sigmaY: 20.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "EDIT ABILITIES",
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  for (var ability in skills[6])
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              59, 96, 125, 139),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueGrey)),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ability.name,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white)),
                                                                ),
                                                                Text(
                                                                  ability
                                                                      .category,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white30)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Checkbox(
                                                              value: ability
                                                                  .isSelected,
                                                              activeColor:
                                                                  Colors.green,
                                                              onChanged: (bool?
                                                                  newValue) {
                                                                setStateBottomSheet(
                                                                    () {
                                                                  ability.isSelected =
                                                                      newValue;
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  OutlinedButton(
                                                    child: Text(
                                                      "SAVE",
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          90,
                                                                          255,
                                                                          63,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      var _newAbilities = ((skills[6][0].isSelected ? 1 : 0) << 1) |
                                                          ((skills[6][1].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              2) |
                                                          ((skills[6][2].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              3) |
                                                          ((skills[6][3].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              4) |
                                                          ((skills[6][4].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              5) |
                                                          ((skills[6][5].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              11) |
                                                          ((skills[6][6].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              12) |
                                                          ((skills[6][7].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              13) |
                                                          ((skills[6][8].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              14) |
                                                          ((skills[6][9].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              15) |
                                                          ((skills[6][10].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              21) |
                                                          ((skills[6][11].isSelected ? 1 : 0) << 22) |
                                                          ((skills[6][12].isSelected ? 1 : 0) << 23) |
                                                          ((skills[6][13].isSelected ? 1 : 0) << 24) |
                                                          ((skills[6][14].isSelected ? 1 : 0) << 25);
                                                      setState(() {
                                                        databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .abilities = _newAbilities;
                                                            databaseService.updateTeam(
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          34.0)),
                                                      side: const BorderSide(
                                                          width: 2.0,
                                                          color: Color.fromRGBO(
                                                              90, 255, 63, 1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              });
                            });
                      },
                      child: Text("CHANGE >",
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white30)),
                    )
                  ],
                ),
                Text("AUTON",
                    style: GoogleFonts.getFont("Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white30)),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(155, 155, 155, 0.5),
                          width: 1.0),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var strength in skills[2])
                          Row(
                            children: [
                              const Icon(Icons.check,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                        for (var strength in skills[3])
                          Row(
                            children: [
                              const Icon(Icons.close,
                                  color: Color.fromRGBO(255, 63, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setStateBottomSheet) {
                                return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 20.0,
                                          sigmaY: 20.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "EDIT ABILITIES",
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  for (var ability in skills[6])
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              59, 96, 125, 139),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueGrey)),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ability.name,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white)),
                                                                ),
                                                                Text(
                                                                  ability
                                                                      .category,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white30)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Checkbox(
                                                              value: ability
                                                                  .isSelected,
                                                              activeColor:
                                                                  Colors.green,
                                                              onChanged: (bool?
                                                                  newValue) {
                                                                setStateBottomSheet(
                                                                    () {
                                                                  ability.isSelected =
                                                                      newValue;
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  OutlinedButton(
                                                    child: Text(
                                                      "SAVE",
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          90,
                                                                          255,
                                                                          63,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      var _newAbilities = ((skills[6][0].isSelected ? 1 : 0) << 1) |
                                                          ((skills[6][1].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              2) |
                                                          ((skills[6][2].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              3) |
                                                          ((skills[6][3].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              4) |
                                                          ((skills[6][4].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              5) |
                                                          ((skills[6][5].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              11) |
                                                          ((skills[6][6].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              12) |
                                                          ((skills[6][7].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              13) |
                                                          ((skills[6][8].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              14) |
                                                          ((skills[6][9].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              15) |
                                                          ((skills[6][10].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              21) |
                                                          ((skills[6][11].isSelected ? 1 : 0) << 22) |
                                                          ((skills[6][12].isSelected ? 1 : 0) << 23) |
                                                          ((skills[6][13].isSelected ? 1 : 0) << 24) |
                                                          ((skills[6][14].isSelected ? 1 : 0) << 25);
                                                      setState(() {
                                                        databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .abilities = _newAbilities;
                                                            databaseService.updateTeam(
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          34.0)),
                                                      side: const BorderSide(
                                                          width: 2.0,
                                                          color: Color.fromRGBO(
                                                              90, 255, 63, 1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              });
                            });
                      },
                      child: Text("CHANGE >",
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white30)),
                    )
                  ],
                ),
                Text("DRIVER CONTROLLED",
                    style: GoogleFonts.getFont("Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white30)),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(155, 155, 155, 0.5),
                          width: 1.0),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var strength in skills[4])
                          Row(
                            children: [
                              const Icon(Icons.check,
                                  color: Color.fromRGBO(90, 255, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                        for (var strength in skills[5])
                          Row(
                            children: [
                              const Icon(Icons.close,
                                  color: Color.fromRGBO(255, 63, 63, 1)),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(strength,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.getFont("Poppins",
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13))),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                            // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setStateBottomSheet) {
                                return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 20.0,
                                          sigmaY: 20.0,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "EDIT ABILITIES",
                                                    style: GoogleFonts.getFont(
                                                        'Poppins',
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  for (var ability in skills[6])
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              59, 96, 125, 139),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueGrey)),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ability.name,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white)),
                                                                ),
                                                                Text(
                                                                  ability
                                                                      .category,
                                                                  style: GoogleFonts.getFont(
                                                                      'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.white30)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Checkbox(
                                                              value: ability
                                                                  .isSelected,
                                                              activeColor:
                                                                  Colors.green,
                                                              onChanged: (bool?
                                                                  newValue) {
                                                                setStateBottomSheet(
                                                                    () {
                                                                  ability.isSelected =
                                                                      newValue;
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  OutlinedButton(
                                                    child: Text(
                                                      "SAVE",
                                                      style: GoogleFonts.getFont(
                                                          "Poppins",
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                          90,
                                                                          255,
                                                                          63,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      var _newAbilities = ((skills[6][0].isSelected ? 1 : 0) << 1) |
                                                          ((skills[6][1].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              2) |
                                                          ((skills[6][2].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              3) |
                                                          ((skills[6][3].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              4) |
                                                          ((skills[6][4].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              5) |
                                                          ((skills[6][5].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              11) |
                                                          ((skills[6][6].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              12) |
                                                          ((skills[6][7].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              13) |
                                                          ((skills[6][8].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              14) |
                                                          ((skills[6][9].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              15) |
                                                          ((skills[6][10].isSelected
                                                                  ? 1
                                                                  : 0) <<
                                                              21) |
                                                          ((skills[6][11].isSelected ? 1 : 0) << 22) |
                                                          ((skills[6][12].isSelected ? 1 : 0) << 23) |
                                                          ((skills[6][13].isSelected ? 1 : 0) << 24) |
                                                          ((skills[6][14].isSelected ? 1 : 0) << 25);
                                                      setState(() {
                                                        databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .abilities = _newAbilities;
                                                            databaseService.updateTeam(
                                                          databaseService
                                                              .compTeams
                                                              .where((team) =>
                                                                  team.teamNumber ==
                                                                  databaseService
                                                                      .userTeamNumber)
                                                              .toList()[0]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          34.0)),
                                                      side: const BorderSide(
                                                          width: 2.0,
                                                          color: Color.fromRGBO(
                                                              90, 255, 63, 1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              });
                            });
                      },
                      child: Text("CHANGE >",
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white30)),
                    )
                  ],
                ),
                Text("ENDGAME",
                    style: GoogleFonts.getFont("Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white30)),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(155, 155, 155, 0.5),
                          width: 1.0),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
