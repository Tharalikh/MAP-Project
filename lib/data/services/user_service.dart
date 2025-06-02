import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future addUserInfo(Map<String, dynamic> userMap, String id) async {
    return await FirebaseFirestore.instance.collection('users').doc(id).set(userMap);
  }
}

