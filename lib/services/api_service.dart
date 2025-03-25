import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leafmusic_2/models/artist.dart';
import '../models/song.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";

  static Future<List<Song>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/songs/random"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải dữ liệu");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  static Future<List<Artist>> fetchArtists() async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/artists/random"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Artist.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải dữ liệu");
      }
    }catch(e){
      throw Exception("Lỗi kết nối: $e");
    }
  }



}
