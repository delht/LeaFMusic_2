import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
