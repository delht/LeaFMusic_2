import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('http://$ip/api/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Sai tài khoản hoặc mật khẩu');
    }
  }


  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('http://$ip/api/users/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Đăng ký thất bại';
      throw Exception(error);
    }
  }


  Future<void> changePassword({required String userId, required String oldPassword, required String newPassword,}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Chưa đăng nhập');
    }

    final url = Uri.parse('http://$ip/api/users/change-password?id=$userId&old=$oldPassword&newpass=$newPassword');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ?? 'Đổi mật khẩu thất bại';
      throw Exception(error);
    }
  }



}
