import 'package:flutter/material.dart';
import '../model/event_model.dart';
import '../services/event_service.dart';

class MyEventsViewModel extends ChangeNotifier {
  final List<EventModel> _myEvents = [];
  final EventService _eventService = EventService();
  bool _isLoading = false;

  List<EventModel> get myEvents => _myEvents;
  bool get isLoading => _isLoading;

  // Fetch user's created events from Firebase
  Future<void> fetchMyEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For now, we'll get all events. In a real app, you'd filter by user ID
      final allEvents = await _eventService.getAllEvents();
      _myEvents.clear();
      _myEvents.addAll(allEvents);
    } catch (e) {
      print('Error fetching my events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addEvent(EventModel event) {
    // Only add to local list if it's not already there
    if (!_myEvents.any((e) => e.id == event.id)) {
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
}