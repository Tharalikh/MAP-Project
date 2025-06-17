import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import '../services/user_service.dart';
import '../services/shared_preference.dart';
import '../model/organizer_model.dart';
import '../services/organizer_service.dart';

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

  String selectedRole = 'user';

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

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

      final uid = userCred.user!.uid;
      final username = usernameController.text.trim();
      final name = profileNameController.text.trim();
      final phone = phoneController.text.trim();
      final profilePic = profilePicController.text.trim();

      // Save to correct collection
      if (selectedRole == 'organizer') {
        final organizer = OrganizerModel(
          uid: uid,
          username: username,
          name: name,
          email: email,
          phone: phone,
          password: '',
          profilePic: profilePic,
        );
        await OrganizerService().addOrganizerInfo(organizer);
      } else {
        final user = UserModel(
          uid: uid,
          username: username,
          name: name,
          email: email,
          phone: phone,
          password: '',
          profilePic: profilePic,
        );
        await UserService().addUser(user);
      }

      // Save shared preferences
      final prefs = SharedPreferenceHelper();
      await prefs.saveUserId(uid);
      await prefs.saveUsername(username);
      await prefs.saveName(name);
      await prefs.saveEmail(email);
      await prefs.savePhone(phone);
      await prefs.saveProfilePic(profilePic);
      await prefs.saveRole(selectedRole); // <-- important to differentiate role later

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