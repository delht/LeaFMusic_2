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

  /// ==============================================================================

  Future<List<CustomList>> fetchCustomListPublic() async {
    final response = await http.get(Uri.parse("http://$ip/api/customlists/public"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CustomList.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu danh sách thất bại");
    }
  }

  /// ==============================================================================

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

  // =====================================

  Future<void> addSongToCustomList(int idList, int idSong) async {
    final response = await http.post(
      Uri.parse("http://$ip/api/custom-songlists/add?idList=$idList&idSong=$idSong"),
    );

    if (response.statusCode != 200) {
      throw Exception("Không thể thêm bài hát vào danh sách");
    }
  }


  Future<bool> checkSongInCustomList(int idList, int idSong) async {
    final response = await http.get(Uri.parse("http://$ip/api/custom-songlists/contains?idList=$idList&idSong=$idSong"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'] ?? false;
    } else {
      throw Exception("Lỗi kiểm tra bài hát trong danh sách");
    }
  }

  Future<void> removeSongFromCustomList(int idList, int idSong) async {
    final response = await http.delete(Uri.parse('http://$ip/api/custom-songlists/remove?idList=$idList&idSong=$idSong'));
    if (response.statusCode != 200) {
      throw Exception('Xóa bài hát khỏi danh sách thất bại');
    }
  }

  // Future<CustomList> createCustomList(String userId, String name) async {
  //   final response = await http.post(
  //     Uri.parse('http://$ip/api/customlists/add?name=$name&idUser=$userId'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'userId': userId, 'name': name}),
  //   );
  //
  //   if (response.statusCode == 201) {
  //     return CustomList.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Không thể tạo danh sách mới');
  //   }
  // }

///============================================================================

  Future<void> togglePublicStatus(int idList) async {
    final response = await http.put(
      Uri.parse('http://$ip/api/customlists/public/$idList'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể thay đổi trạng thái công khai');
    }
  }


  Future<void> clone(int idList, String idUser) async {
    final response = await http.post(
      Uri.parse("http://$ip/api/customlists/clone?idList=$idList&idUser=$idUser"),
    );

    if (response.statusCode != 200) {
      throw Exception("Clone thất bại");
    }
  }


}