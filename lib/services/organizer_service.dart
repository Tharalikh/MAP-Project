import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future addOrganizerInfo(Map<String, dynamic> userMap, String id) async {
    return await FirebaseFirestore.instance.collection('organizers').doc(id).set(userMap);
  }
}