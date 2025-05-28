import '../../model/user/user_model.dart';
import '../../services/user_service.dart';
import 'dart:io';

class UserRepo {
  final UserService _userService = UserService();

  Future<UserModel?> getUser(String uid) async {
    return await _userService.fetchUser(uid);
  }

  Future<void> createUser(UserModel user) async {
    return await _userService.createUser(user);
  }

  Future<void> updateUser(UserModel user) async {
    return await _userService.updateUser(user);
  }

  Future<void> deleteUser(UserModel uid) async {
    return await _userService.deleteUSer(uid);
  }

  Future<String> uploadProfilePic(File image, String uid) async {
    return await _userService.uploadProfilePicture(image, uid);
  }

  Future<void> removeProfilePic(String uid) async {
    return await _userService.removeProfilePicture(uid);
  }
}
