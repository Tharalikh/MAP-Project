import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/event_model.dart';
import '../model/ticket_model.dart';
import '../services/paymentGateway_service.dart';
import '../services/ticket_service.dart';

class PurchaseViewModel extends ChangeNotifier {
  int _quantity = 1;
  double _pricePerTicket = 0.0;
  int _maxQuantity = 1;

  // Getters
  int get quantity => _quantity;
  double get pricePerTicket => _pricePerTicket;
  double get totalPrice => _pricePerTicket * _quantity;
  int get maxQuantity => _maxQuantity;
  bool get canIncrement => _quantity < _maxQuantity;
  bool get canDecrement => _quantity > 1;
  int get remainingQuantity => _maxQuantity - _quantity;

  // Set ticket price
  void setPrice(double price) {
    _pricePerTicket = price;
    notifyListeners();
  }

  // Set maximum allowed tickets based on event capacity
  void setMaxQuantity(int max) {
    _maxQuantity = max > 0 ? max : 1;
    if (_quantity > _maxQuantity) {
      _quantity = _maxQuantity;
    }
    notifyListeners();
  }

  // Quantity controls
  void increment() {
    if (_quantity < _maxQuantity) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int value) {
    if (value >= 1 && value <= _maxQuantity) {
      _quantity = value;
      notifyListeners();
    }
  }

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  void reset() {
    _quantity = 1;
    _pricePerTicket = 0.0;
    _maxQuantity = 1;
    notifyListeners();
  }

  // Purchase and save tickets
  Future<bool> processPurchase({
    required EventModel event,
    required String userId,
  }) async {
    try {
      // Charge user for total price
      await StripeService.instance.makePayment(totalPrice);

      // Save each ticket separately for quantity
      for (int i = 0; i < _quantity; i++) {
        final ticketId = 'TKT${const Uuid().v4()}';
        final qrCode = TicketModel.generateQRCode(
          ticketId,
          event.id,
          userId,
        );

        final ticket = TicketModel(
          id: ticketId,
          eventId: event.id,
          userId: userId,
          name: event.title,
          location: event.location,
          date: event.date,
          time: event.time,
          price: _pricePerTicket,
          quantity: 1,
          poster: event.poster,
          qrCode: qrCode,
          createdAt: DateTime.now(),
          rating: 0,
          feedback: '',
        );

        await TicketService().createTicket(ticket);
      }

      debugPrint("🎫 All tickets successfully saved.");
      return true;
    } catch (e) {
      debugPrint("❌ Error during purchase: $e");
      return false;
    }
  }
}
