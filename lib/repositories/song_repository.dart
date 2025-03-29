import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class SongRepository {
  final String apiUrl = "http://172.21.13.33:8080/api/songs/random";

  Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load songs");
    }
  }
}
