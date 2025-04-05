import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppPage extends StatefulWidget {
  final DatabaseService databaseService;
  const AboutAppPage(this.databaseService, {Key? key}) : super(key: key);

  @override
  _AboutAppPageState createState() => _AboutAppPageState(databaseService);
}

class _AboutAppPageState extends State<AboutAppPage> {
  final DatabaseService databaseService;
  _AboutAppPageState(this.databaseService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "ABOUT APP",
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
                    "https://cdn.discordapp.com/attachments/949530485023977482/949530873588506644/unknown.png",
                    width: 100,
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/app/LOGOMARK+WORDMARK.png",
                    width: 200,
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      "Optimum is developed by Team Juice 16236. Juice is a NorCal based FIRST Tech Challenge team with 4 high-school seniors and 11 8th/9th graders.",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              Text("ABOUT JUICE 16236",
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
                  SizedBox(
                    width: 250,
                    child: Text(
                      "See the licenses we use!",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showLicensePage(context: context, applicationName: "OPTIMUM", applicationIcon: Container(margin: const EdgeInsets.all(16.0),child: Image.asset("assets/app/icon.png", height: 100,)));
                    },
                    child: Text("SEE >",
                        style: GoogleFonts.getFont("Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white30)),
                  ),
                ],
              ),
              Text("LICENSES",
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
