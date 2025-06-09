import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/organizer_model.dart';

class OrganizerService {
  final CollectionReference _eventCollection = FirebaseFirestore.instance.collection('organizers');

  Future<void> addOrganizerInfo(OrganizerModel organizer) async {
    await _eventCollection.doc(organizer.uid).set(organizer.toMap());
  }

  Future<OrganizerModel> getOrganizerById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('organizers').doc(
        id).get();
    if (doc.exists && doc.data() != null) {
      return OrganizerModel.fromMap(doc.data()!, id);
    } else {
      throw Exception('Organizer not found');
    }
  }

    Future<void> updateOrganizer(OrganizerModel organizer) async {
      await _eventCollection.doc(organizer.uid).update(organizer.toMap());
    }

    Future<void> deleteOrganizer(String id) async {
      await _eventCollection.doc(id).delete();
    }
}