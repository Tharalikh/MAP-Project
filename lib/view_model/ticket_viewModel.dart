import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../model/ticket_model.dart';

class TicketViewModel extends ChangeNotifier {
  int _quantity = 1;
  late double _pricePerTicket;
  late String _eventId;
  late String _eventName;
  late String _eventLocation;
  late String _eventDate;
  late String _eventTime;
  late String _eventPoster;

  List<TicketModel> _tickets = [];
  bool _isLoading = false;

  // Public Getters
  int get quantity => _quantity;
  double get totalPrice => _pricePerTicket * _quantity;
  List<TicketModel> get tickets => _tickets;
  bool get isLoading => _isLoading;

  // Quantity controls
  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int value) {
    _quantity = value > 0 ? value : 1;
    notifyListeners();
  }

  // Event setup
  void setEventData({
    required String eventId,
    required String name,
    required String location,
    required String date,
    required String time,
    required String price,
    required String poster,
  }) {
    _eventId = eventId;
    _eventName = name;
    _eventLocation = location;
    _eventDate = date;
    _eventTime = time;
    _pricePerTicket = double.tryParse(price) ?? 0.0;
    _eventPoster = poster;
    notifyListeners();
  }

  // Save multiple tickets with unique IDs and QR codes
  Future<bool> saveTicket() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint("⚠️ No user logged in");
        return false;
      }

      for (int i = 0; i < _quantity; i++) {
        final ticketId = 'TKT${const Uuid().v4()}';

        final qrCode = TicketModel.generateQRCode(
          ticketId,
          _eventId,
          currentUser.uid,
        );

        final ticketData = {
          'id': ticketId,
          'eventId': _eventId,
          'userId': currentUser.uid,
          'name': _eventName,
          'location': _eventLocation,
          'date': _eventDate,
          'time': _eventTime,
          'price': _pricePerTicket,
          'ticketNumber': i + 1,
          'quantity': _quantity,
          'poster': _eventPoster,
          'qrCode': qrCode,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('tickets')
            .doc(ticketId)
            .set(ticketData);
      }

      debugPrint("✅ Tickets saved successfully");
      return true;
    } catch (e) {
      debugPrint("❌ Error saving tickets: $e");
      return false;
    }
  }

  // Reset internal state
  void clearData() {
    _quantity = 1;
    _tickets.clear();
    notifyListeners();
  }

  // Load tickets for current user
  Future<void> loadUserTickets() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      _tickets = snapshot.docs
          .map((doc) => TicketModel.fromMap(doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Failed to load tickets: $e");
    }
  }

  // Filter active tickets
  List<TicketModel> get activeTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      final dateTime = DateTime.parse("${ticket.date} ${ticket.time}");
      return !dateTime.isBefore(now);
    }).toList();
  }

  // Filter past tickets
  List<TicketModel> get historyTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      final dateTime = DateTime.parse("${ticket.date} ${ticket.time}");
      return dateTime.isBefore(now);
    }).toList();
  }
}
