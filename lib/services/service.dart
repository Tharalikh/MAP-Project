import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class AuthService {
  static Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Normally, fetch user profile from Firestore or your backend here
      // We'll mock with email and displayName for now
      final user = credential.user;
      if (user != null) {
        // Here, you would actually fetch more user details from Firestore
        return UserModel(
          uid: user.uid,
          username: user.email ?? '',
          password: '', // Don't store passwords in real apps!
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          profilePic: user.photoURL ?? '',
        );
      }
      return null;
    } catch (e) {
      print('Firebase login failed: $e');
      return null;
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
