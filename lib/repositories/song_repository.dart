import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class SongRepository {
  // final String apiUrl = "http://${dotenv.env['IPv4']}:8080/api/songs/random";

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<List<Song>> fetchSongsRandom() async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/random"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }

  Future<List<Song>> fetchTop5SongByArtist(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/artist/$id"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }

  Future<List<Song>> fetchSongsByArtist(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/album/$id"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }


}
