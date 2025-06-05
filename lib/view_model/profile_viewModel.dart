import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/shared_preference.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? user;

  Future<void> loadUserData() async {
    print("🔍 Starting to load user data...");
    try {
      final id = await SharedPreferenceHelper().getUserId();
      final username = await SharedPreferenceHelper().getUsername();
      final name = await SharedPreferenceHelper().getName();
      final email = await SharedPreferenceHelper().getEmail();
      final phone = await SharedPreferenceHelper().getPhone();

      print("✅ Loaded from SharedPrefs:");
      print("id: $id, username: $username, name: $name, email: $email, phone: $phone");

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
}
