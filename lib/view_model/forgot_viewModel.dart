import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String email = '';

  void setEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  Future<String?> sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
