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

        // Filter out past events before adding to _allEvents
        final upcomingEvents = _filterUpcomingEvents(events);
        _allEvents.addAll(upcomingEvents);
        _filteredEvents = List.from(_allEvents);

        print("After filtering past events: ${_allEvents.length} upcoming events");

        // Debug print all events with capacity info
        for (int i = 0; i < _allEvents.length; i++) {
          final event = _allEvents[i];
          print("""
          Event $i: 
          Title: ${event.title} 
          Category: ${event.category} 
          Location: ${event.location} 
          Date: ${event.date}
          Capacity: ${event.bookedCount}/${event.capacity}
          Remaining: ${event.remainingCapacity}
          """);
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

  // Helper method to filter out past events
  List<EventModel> _filterUpcomingEvents(List<EventModel> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Start of today

    return events.where((event) {
      try {
        DateTime eventDate = DateTime.parse(event.date);
        DateTime eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);

        // Include events that are today or in the future
        bool isUpcoming = eventDay.isAtSameMomentAs(today) || eventDay.isAfter(today);

        if (!isUpcoming) {
          print("Filtering out past event: ${event.title} - ${event.date}");
        }

        return isUpcoming;
      } catch (e) {
        print("Error parsing date for event '${event.title}': ${event.date} - $e");
        // If date parsing fails, include the event to be safe
        return true;
      }
    }).toList();
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
        print("  Capacity: ${event.bookedCount}/${event.capacity}");
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

  // Optional: Method to refresh and check for new upcoming events
  void refreshUpcomingEvents() {
    if (_allEvents.isNotEmpty) {
      final originalCount = _allEvents.length;

      // Re-filter all events to remove any that might have become past events
      final upcomingEvents = _filterUpcomingEvents(_allEvents);

      _allEvents.clear();
      _allEvents.addAll(upcomingEvents);
      _filteredEvents = List.from(_allEvents);

      if (originalCount != _allEvents.length) {
        print("Removed ${originalCount - _allEvents.length} past events during refresh");
        notifyListeners();
      }
    }
  }

  // Helper method to get capacity status text
  String getCapacityStatus(EventModel event) {
    if (event.isFullyBooked) {
      return 'Sold Out';
    } else if (event.remainingCapacity < 10) {
      return 'Only ${event.remainingCapacity} left!';
    } else {
      return '${event.remainingCapacity} available';
    }
  }

  // Helper method to get capacity color
  Color getCapacityColor(EventModel event) {
    if (event.isFullyBooked) {
      return Colors.red;
    } else if (event.remainingCapacity < 10) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}