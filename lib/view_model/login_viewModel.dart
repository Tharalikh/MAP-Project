import 'package:flutter/material.dart';
import '../services/service.dart';
import '../model/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<UserModel?> login() async {
    return await AuthService.login(_username, _password);
  }
}
