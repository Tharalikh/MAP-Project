import 'package:flutter/material.dart';
import '/model/event_model.dart';
import '/services/event_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<EventModel> get filteredEvents => _filteredEvents;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get allEventsCount => _allEvents.length;

  final EventService _eventService = EventService();

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("Fetching events from Firebase...");

      final events = await _eventService.getAllEvents();
      print("Fetched ${events.length} events");

      if (events.isEmpty) {
        _errorMessage = 'No events available.';
      } else {
        _allEvents.clear();
        _allEvents.addAll(events);
        _filteredEvents = List.from(_allEvents);

        // Debug print all events
        for (int i = 0; i < _allEvents.length; i++) {
          final event = _allEvents[i];
          print("Event $i: ${event.title} - ${event.category} - ${event.location} - ${event.date}");
        }
      }

    } catch (e) {
      print("Error fetching events: $e");
      _errorMessage = 'Failed to load events: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterEvents({String? category, String? location, String? date}) {
    print("=== FILTER EVENTS ===");
    print("Filter params - Category: $category, Location: $location, Date: $date");
    print("Total events to filter: ${_allEvents.length}");

    _filteredEvents = _allEvents.where((event) {
      bool matches = true;

      // Category filter
      if (category != null && category.isNotEmpty) {
        matches = matches && (event.category.toLowerCase().trim() == category.toLowerCase().trim());
        print("Category check for '${event.title}': ${event.category} == $category -> ${matches}");
      }

      // Location filter
      if (location != null && location.isNotEmpty && matches) {
        matches = matches && (event.location.toLowerCase().trim() == location.toLowerCase().trim());
        print("Location check for '${event.title}': ${event.location} == $location -> ${matches}");
      }

      // Date filter
      if (date != null && date.isNotEmpty && matches) {
        // Try exact match first
        if (event.date == date) {
          matches = true;
        } else {
          // Try parsing and comparing dates
          try {
            DateTime eventDate = DateTime.parse(event.date);
            DateTime filterDate = DateTime.parse(date);
            matches = matches && (
                eventDate.year == filterDate.year &&
                    eventDate.month == filterDate.month &&
                    eventDate.day == filterDate.day
            );
          } catch (e) {
            print("Date parsing error: $e");
            matches = false;
          }
        }
        print("Date check for '${event.title}': ${event.date} == $date -> ${matches}");
      }

      if (matches) {
        print("✓ Event '${event.title}' matches all filters");
      }

      return matches;
    }).toList();

    print("Filtered result: ${_filteredEvents.length} events");
    notifyListeners();
  }

  void clearFilters() {
    print("Clearing all filters - resetting to ${_allEvents.length} events");
    _filteredEvents = List.from(_allEvents);
    notifyListeners();
  }

  Map<String, List<EventModel>> groupedByCategory() {
    final Map<String, List<EventModel>> categoryMap = {};
    for (var event in _filteredEvents) {
      categoryMap.putIfAbsent(event.category, () => []).add(event);
    }
    print("Grouped categories: ${categoryMap.keys.toList()}");
    return categoryMap;
  }
}