import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';

class AlbumRepository {
  // final String apiUrl = "http://${dotenv.env['IPv4']}:${dotenv.env['port']}/api/albums/random";

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";


  Future<List<Album>> fetchAlbums() async {
    // final response = await http.get(Uri.parse(apiUrl));
    final response = await http.get(Uri.parse("http://$ip/api/albums/random"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception("Không thể tải album");
    }
  }

  Future<List<Album>> fetchAlbumsByArtist(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/albums/artist/$id"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception("Không thể tải album");
    }
  }



}
