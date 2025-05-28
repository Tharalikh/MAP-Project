import 'package:flutter/material.dart';
import '../../../data/services/service.dart';

class RegisterViewModel extends ChangeNotifier {
  String _username = '';
  String _profileName = '';
  String _email = '';
  String _phoneNum = '';
  String _password = '';
  String _confirmPassword = '';

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setProfileName(String value) {
    _profileName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhoneNum(String value) {
    _phoneNum = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  Future<bool> register() async {
    if (_password != _confirmPassword) return false;
    return await AuthService.mockRegister(_username, _profileName, _email, _phoneNum, _password);
  }
}