import 'package:flutter/material.dart';

class PurchaseViewModel extends ChangeNotifier {
  int quantity = 1;
  double _pricePerTicket = 0.0;

  // Getter and setter for pricePerTicket
  double get pricePerTicket => _pricePerTicket;

  void setPrice(double price) {
    _pricePerTicket = price;
    notifyListeners();
  }

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

  double get totalPrice => _pricePerTicket * quantity;
}
