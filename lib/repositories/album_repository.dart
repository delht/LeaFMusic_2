import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';

class AlbumRepository {
  final String apiUrl = "http://172.21.13.33:8080/api/albums/random";

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception("Không thể tải album");
    }
  }
}
