import 'package:flutter/material.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final String priceMonthly = 'RM 15 / month';
  final String priceYearly = 'RM 120 / year';

  final List<String> benefits = [
    '🎁 Receive weekly and monthly vouchers for ticket discounts.',
    '💬 Get the latest updates on exclusive member-only concerts and events.',
    '💡 Enjoy early access to special discounts and promotions.',
  ];

  bool isSubscribed = false;

  void toggleSubscription() {
    isSubscribed = !isSubscribed;
    notifyListeners();
  }
}
