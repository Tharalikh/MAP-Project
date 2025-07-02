import 'package:flutter/material.dart';
import '../model/event_model.dart';
import '../services/event_service.dart';

class SearchViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];
  String _searchQuery = '';

  List<EventModel> get filteredEvents => _filteredEvents;
  String get searchQuery => _searchQuery;
  String selectedCity = 'All Cities'; // example field

  SearchViewModel() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    _allEvents = await _eventService.getAllEvents();

    final now = DateTime.now();
    _allEvents = _allEvents.where((event) {
      DateTime eventDate = DateTime.parse(event.date);
      return eventDate.isAfter(now);
    }).toList();

    print("Fetched events: ${_allEvents.length}");
    _filteredEvents = _allEvents;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredEvents = _allEvents;
    } else {
      _filteredEvents = _allEvents
          .where((event) => event.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    print("Filtered events: ${_filteredEvents.length}");
    notifyListeners();
  }

}
