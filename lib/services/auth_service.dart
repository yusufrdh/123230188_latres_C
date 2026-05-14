import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'loggedInUser';

  Future<bool> login(String username, String password) async {
    // Validasi otorisasi: Username bebas, password wajib NIM Anda
    if (username.isNotEmpty && password == '123230188') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, username); // Menyimpan username di session
      return true;
    }
    return false;
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}