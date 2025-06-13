import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // New method to get events created by specific user
  Future<List<EventModel>> getEventsByUserId(String userId) async {
    final snapshot = await _eventCollection
        .where('creatorId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventModel.fromMap(data);
    }).toList();
  }

  // New method to get current user's events
  Future<List<EventModel>> getCurrentUserEvents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }
    return getEventsByUserId(currentUser.uid);
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

  // Check if current user has any events
  Future<bool> currentUserHasEvents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final snapshot = await _eventCollection
        .where('creatorId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();
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