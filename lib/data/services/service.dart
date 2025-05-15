class AuthService {
  static Future<bool> mockLogin(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    return username == 'user' && password == 'user123';
  }

  static Future<bool> mockRegister(
    String username,
    String profileName,
    String email,
    String phoneNum,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return username.isNotEmpty && email.contains('@') && password.length >= 6;
  }
}
