import 'package:festquest/services/shared_preference.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';

class EditProfileViewModel extends ChangeNotifier {
  String userName = '';
  String profileName = '';
  String email = '';
  String phone = '';

  final usernameController = TextEditingController();
  final profileNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

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

  Future<UserModel?> updateUser() async {
    final uid = await SharedPreferenceHelper().getUserId();
    if (uid == null) {
      return null;
    }
    final updatedUser = UserModel(
      uid: uid,
      username: userName,
      name: profileName,
      email: email,
      phone: phone,
      password: '',
      profilePic: '',
    );
    try {
    await UserService().updateUser(updatedUser);
    await SharedPreferenceHelper().saveUsername(userName);
    await SharedPreferenceHelper().saveName(profileName);
    await SharedPreferenceHelper().saveEmail(email);
    await SharedPreferenceHelper().savePhone(phone);
    return updatedUser;
    } catch (e) {
      print('Failed updating user: $e');
      return null;
    }
  }

  Future<void> loadCurrentUser() async {
    final id = await SharedPreferenceHelper().getUserId();
    final username = await SharedPreferenceHelper().getUsername();
    final name = await SharedPreferenceHelper().getName();
    final emailData = await SharedPreferenceHelper().getEmail();
    final phoneData = await SharedPreferenceHelper().getPhone();

    userName = username ?? '';
    profileName = name ?? '';
    email = emailData ?? '';
    phone = phoneData ?? '';

    notifyListeners();
    print("✅ Loaded username: $userName");

  }

}
