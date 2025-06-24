import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      // Process payment first
      await StripeService.instance.makePayment(totalPrice);

      // Generate unique ticket ID
      final ticketId = 'TKT${const Uuid().v4()}';

      // Generate unique QR code for the ticket
      final qrCode = TicketModel.generateQRCode(
        ticketId,
        event.id ?? '',
        userId,
      );

      final ticket = TicketModel(
        id: ticketId,
        eventId: event.id ?? '',
        userId: userId,
        name: event.title ?? '',
        location: event.location ?? '',
        date: event.date ?? '',
        time: event.time ?? '',
        price: double.tryParse(event.price ?? '0') ?? 0.0,
        quantity: quantity,
        poster: event.poster ?? '',
        qrCode: qrCode, // Added QR code to ticket
        createdAt: DateTime.now(),
        rating: 0,
        feedback: '',
      );

      // Save ticket with QR code to Firestore
      await TicketService().createTicket(ticket);

      print("✅ Ticket successfully saved to Firestore with QR code: $qrCode");
      return true;
    } catch (e) {
      debugPrint("❌ Error processing purchase: $e");
      return false;
    }
  }
}
