import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../model/event_model.dart';
import '../services/event_service.dart';

class CreateEventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  String title = '';
  String description = '';
  String date = '';
  String time = '';
  String price = '';
  String location = '';
  String poster = '';
  String category = '';

  void setTitle(String value) => title = value;
  void setDescription(String value) => description = value;
  void setDate(String value) => date = value;
  void setTime(String value) => time = value;
  void setPrice(String value) => price = value;
  void setLocation(String value) => location = value;
  void setPoster(String value) => poster = value;
  void setCategory(String value) => category = value;

  Future<bool> saveEvent() async {
    try {
      String id = randomAlphaNumeric(10);
      EventModel event = EventModel(
        id: id,
        title: title,
        description: description,
        date: date,
        time: time,
        price: price,
        poster: poster,
        location: location,
        category: category,
      );
      await _eventService.createEvent(event);
      return true;
    } catch (e) {
      print('Error saving event: $e');
      return false;
    }
  }
}