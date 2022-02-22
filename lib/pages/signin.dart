import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/gradientOutlinedButton.dart';
import 'homepage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var _formStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: _formStep == 0
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "ENTER YOUR TEAM NUMBER",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w200,
                          textStyle: const TextStyle(
                              fontSize: 36, color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      keyboardAppearance: Brightness.dark,
                      autocorrect: false,
                      cursorColor: Color.fromRGBO(90, 255, 63, 1),
                      decoration: InputDecoration(
                          fillColor: Color.fromRGBO(90, 255, 63, 1),
                          hintText: "16236",
                          hintStyle: TextStyle(color: Colors.white30)),
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                      maxLength: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GradientOutlinedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          setState(() {
                            _formStep = 2;
                          });
                        },
                        // style: OutlinedButton.styleFrom(
                        //   padding: const EdgeInsets.only(left: 36, right: 36),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(34.0)),
                        //   side: const BorderSide(
                        //       width: 2.0, color: Color.fromRGBO(90, 255, 63, 1)),
                        // ),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(90, 255, 63, 1),
                          Color.fromRGBO(57, 177, 7, 1)
                        ]),
                        child: Text(
                          "NEXT",
                          style: GoogleFonts.getFont("Poppins",
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(90, 255, 63, 1),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20)),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        print("ok so my dudes we got a loner");
                        setState(() {
                          _formStep = 2;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Continuing as Guest..."),
                        ));
                      },
                      child: Text(
                        "I AM NOT ASSOCIATED WITH A TEAM",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont("Poppins",
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                    color: Color.fromRGBO(90, 255, 63, 1),
                                    offset: Offset(0, -10))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromRGBO(90, 255, 63, 1),
                              decorationThickness: 4,
                              decorationStyle: TextDecorationStyle.solid,
                            )),
                      ),
                    )
                  ],
                ),
              ))
            : (_formStep == 2
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "ENTER YOUR COMPETITION ID",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w200,
                              textStyle: const TextStyle(
                                  fontSize: 36, color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const TextField(
                          textCapitalization: TextCapitalization.characters,
                          // autofocus: true,
                          keyboardAppearance: Brightness.dark,
                          autocorrect: false,
                          cursorColor: Color.fromRGBO(90, 255, 63, 1),
                          decoration: InputDecoration(
                              fillColor: Color.fromRGBO(90, 255, 63, 1),
                              hintText: "USCANOSUQ",
                              hintStyle: TextStyle(color: Colors.white30)),
                          style: TextStyle(color: Colors.white, fontSize: 30),
                          textAlign: TextAlign.center,
                          maxLength: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GradientOutlinedButton(
                            onPressed: () async {
                              HapticFeedback.heavyImpact();
                              DatabaseService databaseService =
                                  DatabaseService();
                              await databaseService.initService(16236, "uscanosuq");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(databaseService)));
                            },
                            // style: OutlinedButton.styleFrom(
                            //   padding: const EdgeInsets.only(left: 36, right: 36),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(34.0)),
                            //   side: const BorderSide(
                            //       width: 2.0, color: Color.fromRGBO(90, 255, 63, 1)),
                            // ),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(90, 255, 63, 1),
                              Color.fromRGBO(57, 177, 7, 1)
                            ]),
                            child: Text(
                              "DONE",
                              style: GoogleFonts.getFont("Poppins",
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(90, 255, 63, 1),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20)),
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 66.0 + 16.0,
                                            bottom: 16.0,
                                            left: 16.0,
                                            right: 16.0,
                                          ),
                                          margin:
                                              const EdgeInsets.only(top: 66.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(29, 29, 29, 1),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 10.0,
                                                offset: Offset(0.0, 10.0),
                                              ),
                                            ],
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize
                                                  .min, // To make the card compact
                                              children: <Widget>[
                                                Text(
                                                  "Are We Right?",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(height: 16.0),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                        text:
                                                            'Are you competing at ',
                                                      ),
                                                      TextSpan(
                                                        style: const TextStyle()
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        text:
                                                            'SUNNYVALE (USCANORSUN)',
                                                      ),
                                                      const TextSpan(
                                                        style: TextStyle(),
                                                        text:
                                                            '? \n\nIf you are, hit YES below and good luck, if not search for your competition ID ',
                                                      ),
                                                      TextSpan(
                                                        style: TextStyle()
                                                            .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 16,
                                                        ),
                                                        text: 'here',
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                const url =
                                                                    'https://ftc-events.firstinspires.org/';
                                                                if (await canLaunch(
                                                                    url)) {
                                                                  await launch(
                                                                    url,
                                                                    forceSafariVC:
                                                                        false,
                                                                  );
                                                                }
                                                              },
                                                      ),
                                                      const TextSpan(
                                                        style: TextStyle(),
                                                        text: '.',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 24.0),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      TextButton(
                                                        onPressed: () => () {},
                                                        child:
                                                            const Text("YES!"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("No :("),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16.0,
                                          right: 16.0,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            radius: 66.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            "USE MY LOCATION TO FIND MY COMPETITION",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont("Poppins",
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                        color: Color.fromRGBO(90, 255, 63, 1),
                                        offset: Offset(0, -10))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromRGBO(90, 255, 63, 1),
                                  decorationThickness: 4,
                                  decorationStyle: TextDecorationStyle.solid,
                                )),
                          ),
                        )
                      ],
                    ),
                  ))
                : const Text(
                    "Oh No! Something went wrong, restart this app.")));
  }
}
