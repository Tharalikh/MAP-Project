import 'package:flutter/material.dart';
import '../../../data/services/shared_preference.dart';
import '../../../data/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewModel extends ChangeNotifier {
  String username = '';
  String name = '';
  String email = '';
  String phoneNum = '';
  String password = '';
  String confirmPassword = '';

  final SharedPreferenceHelper _prefs = SharedPreferenceHelper();
  final UserService _userService = UserService();

  void updateField({
    String? username,
    String? name,
    String? email,
    String? phoneNum,
    String? password,
    String? confirmPassword,
  }) {
    if (username != null) this.username = username;
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (phoneNum != null) this.phoneNum = phoneNum;
    if (password != null) this.password = password;
    if (confirmPassword != null) this.confirmPassword = confirmPassword;
    notifyListeners();
  }

  bool validateForm() {
    return username.isNotEmpty &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        phoneNum.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  Future<String?> register() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final userMap = {
        "username": username,
        "name": name,
        "email": email,
        "phoneNum": phoneNum,
        "id": uid,
      };

      await _prefs.saveUsername(username);
      await _prefs.saveName(name);
      await _prefs.saveEmail(email);
      await _prefs.savePhone(phoneNum);
      await _prefs.saveUserId(uid);
      await _userService.addUserInfo(userMap, uid);

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "unexpected_error";
    }
  }
}
