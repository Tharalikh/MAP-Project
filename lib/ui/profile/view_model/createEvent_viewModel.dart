import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../../../data/model/event/event_model.dart';
import '../../../data/services/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  String title = '';
  String description = '';
  DateTime? date;
  String location = '';

  void update({
    String? title,
    String? description,
    DateTime? date,
    String? location,
  }) {
    if (title != null) this.title = title;
    if (description != null) this.description = description;
    if (date != null) this.date = date;
    if (location != null) this.location = location;
    notifyListeners();
  }

  bool isValid() {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        date != null &&
        location.isNotEmpty;
  }

  Future<String?> createEvent() async {
    try {
      final id = randomAlphaNumeric(10);
      final event = EventModel(
        id: id,
        title: title,
        description: description,
        date: date!,
        location: location,
      );
      await _eventService.addEvent(event);
      return null; // success
    } catch (e) {
      return "Error: $e";
    }
  }
}
