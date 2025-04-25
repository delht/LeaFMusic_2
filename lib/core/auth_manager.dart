import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {

  ///Lưu thông tin khi đăng nhập (SharedPreferences)
  static Future<void> saveUserInfo({
    required String token,
    required String userId,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', userId);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
  }

  ///Check token coi có chưa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // await prefs.clear(); //DÙNG CÁI NÀY SẼ XÓA TOAFN BỘ, BAO GỒM CẢ SÁNG VÀ TỐI

    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('email');

    await prefs.remove('recent_artist_ids');
    await prefs.remove('recent_genre_ids');

  }

  // ===========================================================================

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

}
