import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:github_sign_in/github_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  var githubClientId = "d36ae2209707b09fac81";
  var githubClientSecret = "ca9051c8a42dd9532bbf505f8c07df0e22f0f0f2";

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple(context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance
        .signInWithCredential(oauthCredential)
        .catchError(
            (error) => showAuthError(context, error.toString().split("] ")[1]));
  }

  Future<UserCredential> signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError(
            (error) => showAuthError(context, error.toString().split("] ")[1]));
  }

  // Future<UserCredential> signInWithGitHub(context) async {
  //   // Create a GitHubSignIn instance
  //   final GitHubSignIn gitHubSignIn = GitHubSignIn(
  //       clientId: githubClientId,
  //       clientSecret: githubClientSecret,
  //       redirectUrl: 'https://optimum-ftc.firebaseapp.com/__/auth/handler');

  //   // Trigger the sign-in flow
  //   final result = await gitHubSignIn.signIn(context);

  //   // Create a credential from the access token
  //   final githubAuthCredential = GithubAuthProvider.credential(result.token);

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(githubAuthCredential)
  //       .catchError(
  //           (error) => showAuthError(context, error.toString().split("] ")[1]));
  // }

  Future<void> deleteAccount(BuildContext context) async {
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
                  margin: const EdgeInsets.only(top: 66.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(29, 29, 29, 1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
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
                      mainAxisSize:
                          MainAxisSize.min, // To make the card compact
                      children: <Widget>[
                        Text(
                          "Delete Account",
                          style: GoogleFonts.poppins(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                style: TextStyle(fontSize: 16),
                                text:
                                    "Are you sure you want to delete your account? You cannot recover any data deleted after an account deletion.",
                              ),
                              const TextSpan(
                                style: TextStyle(fontSize: 16),
                                text:
                                    '\n\nIf you want to provide us with feedback, please contact us at ',
                              ),
                              TextSpan(
                                style: const TextStyle().copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                ),
                                text: 'ftcteam16236@gmail.com',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'https://mailto:ftcteam16236@gmail.com?subject=Optimum Login/Signup Issues';
                                    // if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                    );
                                    // }
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
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  HapticFeedback.vibrate();
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .delete();
                                  FirebaseAuth.instance.currentUser?.delete();
                                  Navigator.of(context).pop();
                                  Phoenix.rebirth(context);
                                },
                                child: const Text(
                                  "CONFIRM",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 63, 63, 1)),
                                ),
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 66.0,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    HapticFeedback.vibrate();
    Phoenix.rebirth(context);
  }

  void showAuthError(BuildContext context, String content,
      {String title = "Login Error"}) {
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
                  margin: const EdgeInsets.only(top: 66.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(29, 29, 29, 1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
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
                      mainAxisSize:
                          MainAxisSize.min, // To make the card compact
                      children: <Widget>[
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: const TextStyle(fontSize: 16),
                                text: content,
                              ),
                              const TextSpan(
                                style: TextStyle(fontSize: 16),
                                text:
                                    '\n\nIf this error persists, please contact us at ',
                              ),
                              TextSpan(
                                style: const TextStyle().copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                ),
                                text: 'ftcteam16236@gmail.com',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url =
                                        'mailto:ftcteam16236@gmail.com?subject=Optimum Login/Signup Issues';
                                    // if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                    );
                                    // }
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
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ok"),
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 66.0,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
