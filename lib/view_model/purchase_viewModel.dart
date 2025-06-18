import 'package:flutter/material.dart';

import '../model/event_model.dart';
import '../model/ticket_model.dart';
import '../services/paymentGateway_service.dart';
import '../services/ticket_service.dart';

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

  Future<bool> processPurchase({
    required EventModel event,
    required String userId,
  }) async {
    try {
      await StripeService.instance.makePayment(totalPrice);

      final ticket = TicketModel(
        id: 'TKT${DateTime.now().millisecondsSinceEpoch}',
        eventId: event.id ?? '',
        userId: userId,
        name: event.title ?? '',
        location: event.location ?? '',
        date: event.date ?? '',
        time: event.time ?? '',
        price: double.tryParse(event.price ?? '0') ?? 0.0,
        quantity: quantity,
        poster: event.poster ?? '',
        createdAt: DateTime.now(),
      );

      await TicketService().createTicket(ticket);
      print("✅ Ticket successfully saved to Firestore");
      return true;
    } catch (e) {
      debugPrint("❌ Error processing purchase: $e");
      return false;
    }
  }

}
