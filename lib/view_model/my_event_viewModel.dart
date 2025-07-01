import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/event_model.dart';
import '../services/event_service.dart';
import '../services/ticket_service.dart';

class MyEventsViewModel extends ChangeNotifier {
  final List<EventModel> _myEvents = [];
  final EventService _eventService = EventService();
  final TicketService _ticketService = TicketService();
  bool _isLoading = false;
  final Map<String, int> _ticketCounts = {};

  List<EventModel> get myEvents => _myEvents;
  bool get isLoading => _isLoading;
  Map<String, int> get ticketCounts => _ticketCounts;

  // Fetch current user's created events from Firebase
  Future<void> fetchMyEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get only events created by the current logged-in user
      final userEvents = await _eventService.getCurrentUserEvents();
      _myEvents.clear();
      _myEvents.addAll(userEvents);

      _ticketCounts.clear();
      for (var event in _myEvents) {
        final count = await _ticketService.getTicketCountForEvent(event.id);
        _ticketCounts[event.id] = count;
      }
    } catch (e) {
      print('Error fetching my events: $e');
      // Handle the case where no user is logged in
      _myEvents.clear();
      _ticketCounts.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addEvent(EventModel event) {
    // Only add to local list if it's not already there and belongs to current user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null &&
        event.creatorId == currentUser.uid &&
        !_myEvents.any((e) => e.id == event.id)) {
      _myEvents.add(event);
      notifyListeners();
    }
  }

  Future<void> removeEvent(String id) async {
    try {
      // Remove from Firebase
      await _eventService.deleteEvent(id);
      // Remove from local list
      _myEvents.removeWhere((e) => e.id == id);
      _ticketCounts.remove(id);
      notifyListeners();
    } catch (e) {
      print('Error removing event: $e');
      rethrow;
    }
  }

  void updateEvent(EventModel event) {
    final index = _myEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _myEvents[index] = event;
      notifyListeners();
    }
  }

  EventModel? getEventById(String id) {
    try {
      return _myEvents.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  bool hasEvents() {
    return _myEvents.isNotEmpty;
  }

  int get eventCount => _myEvents.length;

  List<EventModel> getEventsByCategory(String category) {
    return _myEvents.where((e) => e.category == category).toList();
  }

  void clearAllEvents() {
    _myEvents.clear();
    notifyListeners();
  }

  // Get current user ID
  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}