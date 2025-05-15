import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  String name = 'Atharalikh';
  String phone = '+60 01010101111';

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  // You could add loading from user service, etc., later
}
