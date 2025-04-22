import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:leafmusic_2/models/customlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomListRepository {
  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<List<CustomList>> fetchCustomList(String id) async {
    final response = await http.get(Uri.parse("http://$ip/api/customlists/user/$id"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CustomList.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu danh sách thất bại");
    }
  }

  Future<void> addCustomList(String name, String idUser) async {
    final response = await http.post(
      Uri.parse("http://$ip/api/customlists/add?name=$name&idUser=$idUser"),
    );

    if (response.statusCode != 200) {
      throw Exception("Tạo danh sách mới thất bại");
    }
  }

  Future<void> updateCustomList(int idList, String newName) async {
    final response = await http.put(
      Uri.parse("http://$ip/api/customlists/update/$idList?name=$newName"),
    );

    if (response.statusCode != 200) {
      throw Exception("Sửa danh sách thất bại");
    }
  }

  Future<void> deleteCustomList(int idList) async {
    final response = await http.delete(
      Uri.parse("http://$ip/api/customlists/delete/$idList"),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Xóa danh sách thất bại");
    }

  }



}