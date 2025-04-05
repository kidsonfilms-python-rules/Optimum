import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class RobotSettingsPage extends StatefulWidget {
  final DatabaseService databaseService;
  const RobotSettingsPage(this.databaseService, {Key? key}) : super(key: key);

  @override
  _RobotSettingsPageState createState() =>
      _RobotSettingsPageState(databaseService);
}

class _RobotSettingsPageState extends State<RobotSettingsPage> {
  final DatabaseService databaseService;
  _RobotSettingsPageState(this.databaseService);

  final nicknameController = TextEditingController();
  final robotThumbnailControllor = TextEditingController();
  final customColorController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nicknameController.dispose();
    robotThumbnailControllor.dispose();
    customColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "ROBOT",
          style: GoogleFonts.getFont('Poppins',
              fontWeight: FontWeight.w200,
              textStyle: const TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
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
                              .robotThumbnail !=
                          ""
                      ? Image.network(
                          databaseService.compTeams
                              .where((team) =>
                                  team.teamNumber ==
                                  databaseService.userTeamNumber)
                              .toList()[0]
                              .robotThumbnail,
                          cacheHeight: 80,
                        )
                      : Text(
                          "NO ROBOT THUMBNAIL",
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              textStyle: const TextStyle(color: Colors.white)),
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
                                              "ENTER ROBOT THUMBNAIL URL",
                                              style: GoogleFonts.getFont(
                                                  'Poppins',
                                                  fontWeight: FontWeight.w200,
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                            ),
                                            TextField(
                                              controller: robotThumbnailControllor,
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
                                                    textStyle: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            90, 255, 63, 1),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 12)),
                                              ),
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                if (Uri.parse(
                                                            robotThumbnailControllor.text)
                                                        .isAbsolute ||
                                                    robotThumbnailControllor.text == "") {
                                                  setState(() {
                                                    databaseService.compTeams
                                                        .where((team) =>
                                                            team.teamNumber ==
                                                            databaseService
                                                                .userTeamNumber)
                                                        .toList()[0]
                                                        .robotThumbnail = robotThumbnailControllor.text;
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
                                                padding:
                                                    const EdgeInsets.all(16.0),
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
              Text("ROBOT THUMBNAIL",
                  style: GoogleFonts.getFont("Poppins",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white30)),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
