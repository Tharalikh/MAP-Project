import 'package:flutter/material.dart';
import 'package:festquest/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  int currentTabIndex = 0;

  void setTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void sendWelcomeNotification() {
    NotificationService().showNotification(
      id: 1,
      title: 'Welcome!',
      body: 'Thank you for joining FestQuest 🎉',
    );
  }
}
