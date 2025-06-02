import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Firebase login failed: $e');
      return false;
    }
  }

  static Future<bool> mockRegister(
    String username,
    String profileName,
    String email,
    String phoneNum,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return username.isNotEmpty && email.contains('@') && password.length >= 6;
  }
}
