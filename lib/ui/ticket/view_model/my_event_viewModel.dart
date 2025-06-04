import 'package:flutter/material.dart';
import '../../../data/model/Event/event_model.dart';

class MyEventsViewModel extends ChangeNotifier {
  final List<EventModel> _myEvents = [];

  List<EventModel> get myEvents => _myEvents;

  void addEvent(EventModel event) {
    _myEvents.add(event);
    notifyListeners();
  }

  void removeEvent(int id) {
    _myEvents.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
