import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/services/database.dart';
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

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    "https://cdn.discordapp.com/icons/871829127227928616/8f641588fe6d07981d8d02d635323517.webp",
                    cacheHeight: 80,
                  ),
                  const Spacer(),
                  Text("CHANGE >",
                      style: GoogleFonts.getFont("Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white30))
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
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                      databaseService.compTeams
                          .where((team) =>
                              team.teamNumber == databaseService.userTeamNumber)
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
                          backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "CHANGE TEAM NICKNAME",
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.w200,
                                        textStyle: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),
                                  const TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                    keyboardAppearance: Brightness.dark,
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
                                      style: GoogleFonts.getFont("Poppins",
                                          textStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  90, 255, 63, 1),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12)),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.heavyImpact();
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(34.0)),
                                      side: const BorderSide(
                                          width: 2.0,
                                          color:
                                              Color.fromRGBO(90, 255, 63, 1)),
                                    ),
                                  )
                                ],
                              ),
                            );
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
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
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
                          backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter setStateBottomSheet) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "CHANGE TEAM THEME",
                                      style: GoogleFonts.getFont('Poppins',
                                          fontWeight: FontWeight.w200,
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                          itemCount: _colorOptions.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 50,
                                                  childAspectRatio: 1,
                                                  mainAxisExtent: 50,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                HapticFeedback.heavyImpact();
                                                setStateBottomSheet(() {
                                                  _chosenColor = index;
                                                });
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: _colorOptions[index],
                                                    border: index ==
                                                            _chosenColor
                                                        ? Border.all(
                                                            color: Colors.white,
                                                            width: 3)
                                                        : null),
                                              ),
                                            );
                                          }),
                                    ),
                                    const TextField(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                      keyboardAppearance: Brightness.dark,
                                      decoration: InputDecoration(
                                          hintText: "or enter HEX (#FF5C00)",
                                          hintStyle:
                                              TextStyle(color: Colors.white30)),
                                      textCapitalization:
                                          TextCapitalization.words,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    OutlinedButton(
                                      child: Text(
                                        "SAVE",
                                        style: GoogleFonts.getFont("Poppins",
                                            textStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    90, 255, 63, 1),
                                                fontWeight: FontWeight.w800,
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
                                                  .theme =
                                              _colorOptions[_chosenColor];
                                        });
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(34.0)),
                                        side: const BorderSide(
                                            width: 2.0,
                                            color:
                                                Color.fromRGBO(90, 255, 63, 1)),
                                      ),
                                    )
                                  ],
                                ),
                              );
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
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
