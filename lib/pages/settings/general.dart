import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ftc_scouting_app/classes/teamConnection.dart';
import 'package:ftc_scouting_app/components/hexColor.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:ftc_scouting_app/services/utils/authService.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralSettingsPage extends StatefulWidget {
  final DatabaseService databaseService;
  const GeneralSettingsPage(this.databaseService, {Key? key}) : super(key: key);

  @override
  _GeneralSettingsPageState createState() =>
      _GeneralSettingsPageState(databaseService);
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  final DatabaseService databaseService;
  _GeneralSettingsPageState(this.databaseService);
  final List<Color> _colorOptions = [
    const Color(0xFFFF5F00),
    const Color.fromARGB(255, 255, 0, 140),
    const Color.fromARGB(255, 119, 0, 255),
    const Color.fromARGB(255, 89, 0, 255),
    const Color.fromARGB(255, 0, 153, 255),
    const Color.fromARGB(255, 0, 213, 228),
    const Color.fromARGB(255, 0, 255, 200),
    const Color.fromARGB(255, 255, 238, 0),
    const Color.fromARGB(255, 255, 51, 0),
    const Color.fromARGB(255, 164, 255, 103),
  ];

  var _chosenColor = -1;

  final nicknameController = TextEditingController();
  final logoController = TextEditingController();
  final customColorController = TextEditingController();
  final headlinerController = TextEditingController();
  final addConnectionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nicknameController.dispose();
    logoController.dispose();
    customColorController.dispose();
    headlinerController.dispose();
    addConnectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _teamConnections = databaseService.compTeams
        .where((team) => team.teamNumber == databaseService.userTeamNumber)
        .toList()[0]
        .connections;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "GENERAL",
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
                    databaseService.compTeams
                                .where((team) =>
                                    team.teamNumber ==
                                    databaseService.userTeamNumber)
                                .toList()[0]
                                .logo !=
                            ""
                        ? Image.network(
                            databaseService.compTeams
                                .where((team) =>
                                    team.teamNumber ==
                                    databaseService.userTeamNumber)
                                .toList()[0]
                                .logo,
                            width: 80,
                          )
                        : Text(
                            "NO LOGO",
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                textStyle:
                                    const TextStyle(color: Colors.white)),
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
                              return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 20.0,
                                        sigmaY: 20.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: Colors.black26,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "ENTER TEAM LOGO URL",
                                                style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ),
                                              TextField(
                                                controller: logoController,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                keyboardAppearance:
                                                    Brightness.dark,
                                                autofocus: true,
                                                keyboardType: TextInputType.url,
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              OutlinedButton(
                                                child: Text(
                                                  "SAVE",
                                                  style: GoogleFonts.getFont(
                                                      "Poppins",
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      90,
                                                                      255,
                                                                      63,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12)),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.heavyImpact();
                                                  if (Uri.parse(logoController
                                                              .text)
                                                          .isAbsolute ||
                                                      logoController.text ==
                                                          "") {
                                                    setState(() {
                                                      databaseService.compTeams
                                                          .where((team) =>
                                                              team.teamNumber ==
                                                              databaseService
                                                                  .userTeamNumber)
                                                          .toList()[0]
                                                          .logo = logoController.text;
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
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      )));
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
                Text("TEAM LOGO",
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
                    Text(
                        databaseService.compTeams
                            .where((team) =>
                                team.teamNumber ==
                                databaseService.userTeamNumber)
                            .toList()[0]
                            .teamNickname,
                        style: GoogleFonts.getFont("Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white)),
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
                              return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 20.0,
                                        sigmaY: 20.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: Colors.black26,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "CHANGE TEAM NICKNAME",
                                                style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ),
                                              TextField(
                                                controller: nicknameController,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                keyboardAppearance:
                                                    Brightness.dark,
                                                autofocus: true,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              OutlinedButton(
                                                child: Text(
                                                  "SAVE",
                                                  style: GoogleFonts.getFont(
                                                      "Poppins",
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      90,
                                                                      255,
                                                                      63,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12)),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.heavyImpact();
                                                  setState(() {
                                                    databaseService.compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .teamNickname =
                                                        nicknameController.text;
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
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      )));
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
                Text("TEAM NICKNAME",
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
                    Container(
                      width: 250,
                      child: Text(
                          databaseService.compTeams
                              .where((team) =>
                                  team.teamNumber ==
                                  databaseService.userTeamNumber)
                              .toList()[0]
                              .teamHeadliner,
                          style: GoogleFonts.getFont("Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white)),
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
                              return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 20.0,
                                        sigmaY: 20.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: Colors.black26,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "CHANGE TEAM HEADLINER",
                                                style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w200,
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ),
                                              TextField(
                                                controller: headlinerController,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                keyboardAppearance:
                                                    Brightness.dark,
                                                autofocus: true,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              OutlinedButton(
                                                child: Text(
                                                  "SAVE",
                                                  style: GoogleFonts.getFont(
                                                      "Poppins",
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      90,
                                                                      255,
                                                                      63,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12)),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.heavyImpact();
                                                  setState(() {
                                                    databaseService.compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .teamHeadliner =
                                                        headlinerController
                                                            .text;
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
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                      )));
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
                Text("TEAM HEADLINER",
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
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: databaseService.compTeams
                              .where((team) =>
                                  team.teamNumber ==
                                  databaseService.userTeamNumber)
                              .toList()[0]
                              .theme),
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            border: Border.all(
                                              color: Colors.black26,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "CHANGE TEAM THEME",
                                                  style: GoogleFonts.getFont(
                                                      'Poppins',
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20)),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                Expanded(
                                                  child: GridView.builder(
                                                      itemCount: _colorOptions
                                                          .length,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  50,
                                                              childAspectRatio:
                                                                  1,
                                                              mainAxisExtent:
                                                                  50,
                                                              crossAxisSpacing:
                                                                  20,
                                                              mainAxisSpacing:
                                                                  20),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback
                                                                .heavyImpact();
                                                            setStateBottomSheet(
                                                                () {
                                                              _chosenColor =
                                                                  index;
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color:
                                                                    _colorOptions[
                                                                        index],
                                                                border: index ==
                                                                        _chosenColor
                                                                    ? Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            3)
                                                                    : null),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                TextField(
                                                  onChanged: (val) {
                                                    _chosenColor = -1;
                                                  },
                                                  controller:
                                                      customColorController,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  keyboardAppearance:
                                                      Brightness.dark,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          "or enter HEX (#FF5C00)",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.white30)),
                                                  textCapitalization:
                                                      TextCapitalization.words,
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
                                                                color: Color
                                                                    .fromRGBO(
                                                                        90,
                                                                        255,
                                                                        63,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 12)),
                                                  ),
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .heavyImpact();
                                                    var colorVal =
                                                        _colorOptions[0];
                                                    if (_chosenColor == -1 &&
                                                        customColorController
                                                            .text.isNotEmpty &&
                                                        customColorController
                                                            .text
                                                            .contains("#")) {
                                                      colorVal = HexColor(
                                                          customColorController
                                                              .text);
                                                    } else {
                                                      colorVal = _colorOptions[
                                                          _chosenColor];
                                                    }
                                                    setState(() {
                                                      databaseService.compTeams
                                                          .where((team) =>
                                                              team.teamNumber ==
                                                              databaseService
                                                                  .userTeamNumber)
                                                          .toList()[0]
                                                          .theme = colorVal;
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
                                                  style:
                                                      OutlinedButton.styleFrom(
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
                Text("TEAM THEME",
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
                        for (var connection in _teamConnections)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: FaIcon(
                                  connection.provider ==
                                          TeamConnectionProvider.DISCORD
                                      ? FontAwesomeIcons.discord
                                      : (connection.provider ==
                                              TeamConnectionProvider.EMAIL
                                          ? FontAwesomeIcons.envelope
                                          : (connection.provider ==
                                                  TeamConnectionProvider.PHONE
                                              ? FontAwesomeIcons.phoneAlt
                                              : (connection.provider ==
                                                      TeamConnectionProvider
                                                          .WHATSAPP
                                                  ? FontAwesomeIcons.whatsapp
                                                  : (FontAwesomeIcons
                                                      .question)))),
                                  color: connection.provider ==
                                          TeamConnectionProvider.DISCORD
                                      ? const Color(0xFF5865F2)
                                      : (connection.provider ==
                                              TeamConnectionProvider.EMAIL
                                          ? const Color(0xFFEA4335)
                                          : (connection.provider ==
                                                  TeamConnectionProvider.PHONE
                                              ? const Color(0xFF34A853)
                                              : const Color(0xFF25D366))),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(connection.username,
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
                                                    "EDIT CONNNECTIONS",
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
                                                  TextField(
                                                    onChanged: (val) {
                                                      _chosenColor = -1;
                                                    },
                                                    controller:
                                                        addConnectionController,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Type in a username/phone number",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white30)),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      databaseService.compTeams
                                                          .where((team) =>
                                                              team.teamNumber ==
                                                              databaseService
                                                                  .userTeamNumber)
                                                          .toList()[0]
                                                          .connections
                                                          .add(TeamConnection(
                                                              TeamConnectionProvider
                                                                  .DISCORD,
                                                              addConnectionController
                                                                  .text));
                                                      addConnectionController
                                                          .clear();

                                                      setStateBottomSheet(() {
                                                        _teamConnections = databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .connections;
                                                      });
                                                    },
                                                    child: Text(
                                                      "Add as Discord",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                        fixedSize:
                                                            MaterialStateProperty
                                                                .all(const Size
                                                                        .fromWidth(
                                                                    200)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(const Color(
                                                                    0xFF5865F2))),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      databaseService.compTeams
                                                          .where((team) =>
                                                              team.teamNumber ==
                                                              databaseService
                                                                  .userTeamNumber)
                                                          .toList()[0]
                                                          .connections
                                                          .add(TeamConnection(
                                                              TeamConnectionProvider
                                                                  .EMAIL,
                                                              addConnectionController
                                                                  .text));
                                                      addConnectionController
                                                          .clear();

                                                      setStateBottomSheet(() {
                                                        _teamConnections = databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .connections;
                                                      });
                                                    },
                                                    child: Text(
                                                      "Add as Email",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                        fixedSize:
                                                            MaterialStateProperty
                                                                .all(const Size
                                                                        .fromWidth(
                                                                    200)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(const Color(
                                                                    0xFFEA4335))),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      HapticFeedback
                                                          .heavyImpact();
                                                      var formattedString = addConnectionController
                                                                  .text
                                                                  .contains(
                                                                      "-") ||
                                                              addConnectionController
                                                                  .text
                                                                  .contains(RegExp(
                                                                      r'/[-!$%^&*()_+|~=`{}\[\]:";<>?,.\/]/'))
                                                          ? addConnectionController
                                                              .text
                                                          : addConnectionController
                                                              .text
                                                              .replaceAllMapped(
                                                                  RegExp(
                                                                      r'(\d{3})(\d{3})(\d+)'),
                                                                  (Match m) =>
                                                                      "(${m[1]}) ${m[2]}-${m[3]}");
                                                      databaseService.compTeams
                                                          .where((team) =>
                                                              team.teamNumber ==
                                                              databaseService
                                                                  .userTeamNumber)
                                                          .toList()[0]
                                                          .connections
                                                          .add(TeamConnection(
                                                              TeamConnectionProvider
                                                                  .PHONE,
                                                              formattedString));
                                                      addConnectionController
                                                          .clear();

                                                      setStateBottomSheet(() {
                                                        _teamConnections = databaseService
                                                            .compTeams
                                                            .where((team) =>
                                                                team.teamNumber ==
                                                                databaseService
                                                                    .userTeamNumber)
                                                            .toList()[0]
                                                            .connections;
                                                      });
                                                    },
                                                    child: Text(
                                                      "Add as Phone",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                        fixedSize:
                                                            MaterialStateProperty
                                                                .all(const Size
                                                                        .fromWidth(
                                                                    200)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(const Color(
                                                                    0xFF34A853))),
                                                  ),
                                                  for (var connection
                                                      in _teamConnections)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          color: connection.provider ==
                                                                  TeamConnectionProvider
                                                                      .DISCORD
                                                              ? const Color.fromARGB(
                                                                  70, 88, 101, 242)
                                                              : (connection.provider ==
                                                                      TeamConnectionProvider
                                                                          .EMAIL
                                                                  ? const Color.fromARGB(
                                                                      70, 234, 68, 53)
                                                                  : (connection.provider == TeamConnectionProvider.PHONE
                                                                      ? const Color.fromARGB(
                                                                          70,
                                                                          52,
                                                                          168,
                                                                          83)
                                                                      : const Color.fromARGB(
                                                                          70,
                                                                          37,
                                                                          211,
                                                                          101))),
                                                          border: Border.all(
                                                            color: connection
                                                                        .provider ==
                                                                    TeamConnectionProvider
                                                                        .DISCORD
                                                                ? const Color(
                                                                    0xFF5865F2)
                                                                : (connection
                                                                            .provider ==
                                                                        TeamConnectionProvider
                                                                            .EMAIL
                                                                    ? const Color(
                                                                        0xFFEA4335)
                                                                    : (connection.provider ==
                                                                            TeamConnectionProvider
                                                                                .PHONE
                                                                        ? const Color(
                                                                            0xFF34A853)
                                                                        : const Color(
                                                                            0xFF25D366))),
                                                          )),
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
                                                                  connection
                                                                      .username,
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
                                                                  connection.provider ==
                                                                          TeamConnectionProvider
                                                                              .DISCORD
                                                                      ? "Discord"
                                                                      : (connection.provider ==
                                                                              TeamConnectionProvider
                                                                                  .EMAIL
                                                                          ? "Email"
                                                                          : (connection.provider == TeamConnectionProvider.PHONE
                                                                              ? "Phone"
                                                                              : "WhatsApp")),
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
                                                          IconButton(
                                                              onPressed: () {
                                                                HapticFeedback
                                                                    .heavyImpact();
                                                                setState(() {
                                                                  setStateBottomSheet(
                                                                      () {
                                                                    _teamConnections
                                                                        .remove(
                                                                            connection);
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
                                                      setState(() {
                                                        databaseService
                                                                .compTeams
                                                                .where((team) =>
                                                                    team.teamNumber ==
                                                                    databaseService
                                                                        .userTeamNumber)
                                                                .toList()[0]
                                                                .connections =
                                                            _teamConnections;
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
                Text("TEAM CONNECTIONS",
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
                    const Text("The point of no return..."),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        AuthService().deleteAccount(context);
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(
                          width: 1.0,
                          color: Color.fromRGBO(255, 63, 63, 1),
                          style: BorderStyle.solid,
                        )),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                            width: 5.0,
                            color: Color.fromRGBO(255, 63, 63, 1),
                            style: BorderStyle.solid,
                          ),
                        )),
                      ),
                      child: Text("DELETE ACCOUNT",
                          style: GoogleFonts.getFont("Poppins",
                              fontSize: 12,
                              color: const Color.fromRGBO(255, 63, 63, 1))),
                    ),
                  ],
                ),
                Text("DELETE ACCOUNT",
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
                    const Text("Leaving so soon?"),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        AuthService().signOut(context);
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(
                          width: 1.0,
                          color: Color.fromRGBO(255, 63, 63, 1),
                          style: BorderStyle.solid,
                        )),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                            width: 5.0,
                            color: Color.fromRGBO(255, 63, 63, 1),
                            style: BorderStyle.solid,
                          ),
                        )),
                      ),
                      child: Text("SIGN OUT",
                          style: GoogleFonts.getFont("Poppins",
                              color: const Color.fromRGBO(255, 63, 63, 1))),
                    ),
                  ],
                ),
                Text("SIGN OUT",
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
