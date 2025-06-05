import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = 'userId';
  static String usernameKey = 'username';
  static String passwordKey = 'password';
  static String nameKey = 'name';
  static String emailKey = 'email';
  static String phoneKey = 'phone';
  static String profilePicKey = 'profilePic';

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUsername(String getUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usernameKey, getUsername);
  }

  Future<bool> savePassword(String getPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(passwordKey, getPassword);
  }

  Future<bool> saveName(String getName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(nameKey, getName);
  }

  Future<bool> saveEmail(String getEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(emailKey, getEmail);
  }

  Future<bool> savePhone(String getPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phoneKey, getPhone);
  }

  Future<bool> saveProfilePic(String getProfilePic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(profilePicKey, getProfilePic);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(passwordKey);
  }

  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneKey);
  }

  Future<String?> getProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profilePicKey);
  }

  // Clear all user data (for logout)
  Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}