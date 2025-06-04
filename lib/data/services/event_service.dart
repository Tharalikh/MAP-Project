import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event/event_model.dart';

class EventService {
  final CollectionReference _eventCollection =
  FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(EventModel event) async {
    await _eventCollection.doc(event.id).set(event.toMap());
  }
}
