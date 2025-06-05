import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../services/shared_preference.dart';
import '../model/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  Future<bool> loginUser() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      final uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      final userModel = await UserService().getUserById(uid); // should return a UserModel

      if (userModel != null) {
        await SharedPreferenceHelper().saveUserId(userModel.uid);
        await SharedPreferenceHelper().saveUsername(userModel.username);
        await SharedPreferenceHelper().saveName(userModel.name);
        await SharedPreferenceHelper().saveEmail(userModel.email);
        await SharedPreferenceHelper().savePhone(userModel.phone);
      } else {
        print('❌ userModel is null. Cannot save to SharedPreferences.');
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
