import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../services/user_service.dart';
import '../services/shared_preference.dart';

class RegisterViewModel extends ChangeNotifier {
  // Form fields
  final usernameController = TextEditingController();
  final profileNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final profilePicController = TextEditingController();

  String? errorMessage;

  Future<bool> registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      errorMessage = "Passwords do not match";
      notifyListeners();
      return false;
    }

    if ([usernameController.text, profileNameController.text, email, phoneController.text, password].any((e) => e.isEmpty)) {
      errorMessage = "Please fill in all fields";
      notifyListeners();
      return false;
    }

    try {
      final UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userModel = UserModel(
        uid: userCred.user!.uid,
        username: usernameController.text.trim(),
        name: profileNameController.text.trim(),
        email: email,
        phone: phoneController.text.trim(),
        password: '',
        profilePic: profilePicController.text.trim(),
      );

      await UserService().addUser(userModel);

      await SharedPreferenceHelper().saveUserId(userModel.uid);
      await SharedPreferenceHelper().saveUsername(userModel.username);
      await SharedPreferenceHelper().saveName(userModel.name);
      await SharedPreferenceHelper().saveEmail(userModel.email);
      await SharedPreferenceHelper().savePhone(userModel.phone);

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? "Registration failed";
      notifyListeners();
      return false;
    }
  }

  void disposeControllers() {
    usernameController.dispose();
    profileNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
