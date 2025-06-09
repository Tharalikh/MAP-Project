import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // Create user
  Future<void> addUser(UserModel user) async {
    await _userCollection.doc(user.uid).set(user.toMap());
  }

  // Read user
  Future<UserModel?> getUserById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    } else {
      throw Exception('User not found');
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _userCollection.doc(user.uid).update(user.toMap());
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    await _userCollection.doc(id).delete();
  }
}
