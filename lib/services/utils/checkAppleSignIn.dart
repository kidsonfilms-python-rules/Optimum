import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await SignInWithApple.isAvailable());
  }
}