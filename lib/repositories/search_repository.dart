import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchRepository {

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<SearchResult> search(String keyword) async {
    final response = await http.get(Uri.parse("http://$ip/api/search?keyword=$keyword"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return SearchResult.fromJson(jsonData);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception("Tìm kiếm thất bại");
    }
  }
}
