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

  // Setters for Event Data
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

  // Save ticket to Firestore
  Future<bool> saveTicket() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("❌ No user logged in");
        return false;
      }

      final ticketId = 'TKT${const Uuid().v4()}';

      final ticketData = {
        'id': ticketId,
        'eventId': _eventId,
        'userId': currentUser.uid,
        'name': _eventName,
        'location': _eventLocation,
        'date': _eventDate,
        'time': _eventTime,
        'price': totalPrice,
        'quantity': _quantity,
        'poster': _eventPoster,
        'createdAt': FieldValue.serverTimestamp(),
      };

      print("📤 Saving ticket: $ticketData");

      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketId)
          .set(ticketData);

      print("✅ Ticket saved successfully");
      return true;
    } catch (e) {
      print("❌ Error saving ticket: $e");
      return false;
    }
  }

  // Load tickets from Firestore for current user
  Future<void> loadUserTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('tickets')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        _tickets = snapshot.docs.map((doc) {
          final data = doc.data();
          return TicketModel.fromMap(data);
        }).toList();
      }
    } catch (e) {
      print("❌ Failed to load tickets: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  List<TicketModel> get activeTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      // Combine date and time
      String dateTimeStr = "${ticket.date} ${ticket.time}";
      DateTime eventDateTime = DateTime.parse(dateTimeStr);
      // Show if event time is now or later
      return !eventDateTime.isBefore(now);
    }).toList();
  }

  List<TicketModel> get historyTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      String dateTimeStr = "${ticket.date} ${ticket.time}";
      DateTime eventDateTime = DateTime.parse(dateTimeStr);
      // Show if event time is before now
      return eventDateTime.isBefore(now);
    }).toList();
  }

}
