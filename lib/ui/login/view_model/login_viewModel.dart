import 'package:flutter/material.dart';
import '../../../data/services/service.dart';

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

  Future<bool> login() async {
    return await AuthService.login(_username, _password);
  }
}
