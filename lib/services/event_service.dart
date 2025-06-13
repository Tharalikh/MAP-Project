import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_model.dart';

class EventService {
  final CollectionReference _eventCollection =
  FirebaseFirestore.instance.collection('events');

  Future<void> createEvent(EventModel event) async {
    await _eventCollection.doc(event.id).set(event.toMap());
  }

  Future<List<EventModel>> getAllEvents() async {
    final snapshot = await _eventCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventModel.fromMap(data);
    }).toList();
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventCollection.doc(eventId).delete();
  }

  Future<void> updateEvent(EventModel event) async {
    await _eventCollection.doc(event.id).update(event.toMap());
  }

  Future<bool> hasEvents() async {
    final snapshot = await _eventCollection.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<EventModel?> getEventById(String id) async {
    final doc = await _eventCollection.doc(id).get();
    if (doc.exists) {
      return EventModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}