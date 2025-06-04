import 'package:flutter/material.dart';
import 'package:festquest/model/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel user;

  ProfileViewModel(this.user);

  String get name => user.name.isNotEmpty ? user.name : 'No Name';
  String get phone => user.phone.isNotEmpty ? user.phone : 'No Phone';

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void updateUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }
}
