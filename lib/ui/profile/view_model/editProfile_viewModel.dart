import 'package:flutter/material.dart';

class EditProfileViewModel extends ChangeNotifier {
  String userName = '';
  String profileName = '';
  String email = '';
  String phone = '';

  void setProfileName(String value) {
    profileName = value;
    notifyListeners();
  }

  void setUserName(String value) {
    userName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  bool saveProfile() {
    return profileName.isNotEmpty && email.contains('@') && phone.length >= 10;
  }
}
