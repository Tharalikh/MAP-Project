import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  int currentTabIndex = 0;

  void setTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
}
