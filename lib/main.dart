import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ftc_scouting_app/pages/signin.dart';
import 'package:ftc_scouting_app/services/utils/checkAppleSignIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: Phoenix(child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      title: 'Optimum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
        cardColor: Colors.black,
        textTheme: TextTheme(
          headline5: GoogleFonts.getFont(
            "Exo",
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 45
          ),
          
          caption: GoogleFonts.getFont(
            "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
          bodyText2: GoogleFonts.getFont(
            "Poppins",
              color: Colors.white,
              fontWeight: FontWeight.w200,
              ),
        ),
      ),
      home: const SignIn(),
    );
  }
}