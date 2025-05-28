import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../model/user/user_model.dart';

class UserService {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _storageRef = FirebaseStorage.instance.ref();

  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _userRef.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Future<void> createUser(UserModel user) async {
    await _userRef.doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _userRef.doc(user.uid).update(user.toMap());
  }

  Future<void> deleteUSer(UserModel user) async {
    await _userRef.doc(user.uid).delete();
    await FirebaseAuth.instance.currentUser?.delete();
    try {
      await _storageRef.child('profile_pics/.jpg').delete();
    } catch (_) {}
  }

  Future<String> uploadProfilePicture(File imageFile, String uid) async {
    final ref = _storageRef.child('profilePic');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> removeProfilePicture(String uid) async {
    try {
      await _storageRef.child('profilePic').delete();
    } catch (_) {}
    await _userRef.doc(uid).update({'profilePic': ''});
  }
}
