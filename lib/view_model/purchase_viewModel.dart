import 'package:flutter/material.dart';

class PurchaseViewModel extends ChangeNotifier {
  int quantity = 1;
  String paymentMethod = '';
  final double pricePerTicket = 120.0;

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  double get total => quantity * pricePerTicket;
}
