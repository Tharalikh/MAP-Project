import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? user;

  Future<void> loadUserData() async {
    try {
      final id = await SharedPreferenceHelper().getUserId();
      final username = await SharedPreferenceHelper().getUsername();
      final name = await SharedPreferenceHelper().getName();
      final email = await SharedPreferenceHelper().getEmail();
      final phone = await SharedPreferenceHelper().getPhone();


      if (id == null || username == null || name == null) {
        print("❌ Missing essential user fields, setting user = null");
        user = null;
      } else {
        user = UserModel(
          uid: id,
          username: username,
          name: name,
          email: email ?? '',
          phone: phone ?? '',
          password: '',
          profilePic: '',
        );
        print("UserModel created: name=${user!.name}, phone=${user!.phone}");
      }

      notifyListeners();
      print("🎉 notifyListeners() called.");
    } catch (e) {
      print("🔥 Error in loadUserData: $e");
      user = null;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await UserService().deleteUser(user.uid);
      await FirebaseAuth.instance.currentUser?.delete();
      await SharedPreferenceHelper().clearPrefs();
    }catch (e) {
      return null;
    }
  }

}
