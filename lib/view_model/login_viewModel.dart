import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../services/shared_preference.dart';
import '../services/organizer_service.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  Future<bool> loginUser() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final prefs = SharedPreferenceHelper();

      // Try user collection first
      try {
        final userModel = await UserService().getUserById(uid);
        if (userModel != null) {
          await prefs.saveUserId(userModel.uid);
          await prefs.saveUsername(userModel.username);
          await prefs.saveName(userModel.name);
          await prefs.saveEmail(userModel.email);
          await prefs.savePhone(userModel.phone);
          await prefs.saveProfilePic(userModel.profilePic);
          await prefs.saveRole('user');
          return true;
        }
      } catch (_) {
        // If not found in users, fall through to check organizer
      }

      // Try organizer collection
      try {
        final organizerModel = await OrganizerService().getOrganizerById(uid);
        if (organizerModel != null) {
          await prefs.saveUserId(organizerModel.uid);
          await prefs.saveUsername(organizerModel.username);
          await prefs.saveName(organizerModel.name);
          await prefs.saveEmail(organizerModel.email);
          await prefs.savePhone(organizerModel.phone);
          await prefs.saveProfilePic(organizerModel.profilePic);
          await prefs.saveRole('organizer');
          return true;
        }
      } catch (_) {
        // Not found in organizer either
      }

      // If both failed
      errorMessage = "User not found in Firestore";
      return false;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? "Login failed";
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

}
