import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class SongRepository {
  // final String apiUrl = "http://${dotenv.env['IPv4']}:8080/api/songs/random";

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<List<Song>> fetchSongsRandom() async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/random"));

    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }

  Future<List<Song>> fetchTop5SongByArtist(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/artist/$id"));

    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }

  Future<List<Song>> fetchSongsByAlbum(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/songs/album/$id"));

    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát thất bại");
    }
  }


  // Future<List<Song>> fetchSongsByAlbum(int id) async {
  //   final response = await http.get(Uri.parse("http://$ip/api/songs/album/$id"));
  //
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => Song.fromJson(json)).toList();
  //   } else {
  //     throw Exception("Lấy dữ liệu bài hát thất bại");
  //   }
  // }


  ///===================================================================================


  Future<List<Song>> fetchSongsFromFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("http://$ip/api/favoritelists/songs/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Lấy danh sách bài hát yêu thích thất bại';
      throw Exception(error);
    }
  }

  Future<void> deleteSongFromFavorite(int songId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw Exception("Thiếu token hoặc userId");
    }

    final url = Uri.parse("http://$ip/api/favoritelists/remove?idUser=$userId&idSong=$songId");

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ?? 'Xóa không thành công';
      throw Exception(error);
    }
  }

  Future<void> addSongToFavorite(int songId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw Exception("Thiếu token hoặc userId");
    }

    final url = Uri.parse("http://$ip/api/favoritelists/add?idUser=$userId&idSong=$songId");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ?? 'Thêm không thành công';
      throw Exception(error);
    }
  }


///===================================================================================


  Future<List<Song>> fetchSongsFromCustomList(int idList) async {
    final response = await http.get(Uri.parse("http://$ip/api/custom-songlists/$idList"));
    if (response.statusCode == 200) {
      List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi lấy bài hát từ custom list");
    }
  }

  Future<void> removeSongFromCustomList(int idList, int idSong) async {
    final url = Uri.parse("http://$ip/api/custom-songlists/remove?idList=$idList&idSong=$idSong");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Xóa bài hát thất bại");
    }
  }


///===================================================================================

  Future<List<Song>> fetchSuggestedSongs({
    required List<int> artistIds,
    required List<int> genreIds,
  }) async {
    final response = await http.post(
      Uri.parse("http://$ip/api/songs/suggest"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'artistIds': artistIds,
        'genreIds': genreIds,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception("Lấy dữ liệu bài hát gợi ý thất bại");
    }
  }









}
