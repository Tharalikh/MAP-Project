import 'package:flutter/material.dart';
import '../../../data/model/Event/event_model.dart';

class MyEventsViewModel extends ChangeNotifier {
  final List<Event> _myEvents = [];

  List<Event> get myEvents => _myEvents;

  void addEvent(Event event) {
    _myEvents.add(event);
    notifyListeners();
  }

  void removeEvent(int id) {
    _myEvents.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
