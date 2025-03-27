import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leafmusic_2/models/album.dart';
import 'package:leafmusic_2/models/artist.dart';
import '../models/song.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.8:8080/api";
  // 192.168.83.1
  // 192.168.1.4

  // ====================================================================

  //Lấy bài hát ngẫu nhiên
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
  //Lấy ca sĩ ngẫu nhiên
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
  //Lấy album ngẫu nhiên
  static Future<List<Album>> featchAlbum() async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/albums/random"));
      if(response.statusCode==200){
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Album.fromJson(json)).toList();
      }else{
        throw Exception("Lổi tải dữ liệu");
      }
    }catch(e){
      throw Exception("Lối kết nối: $e");
    }
  }

  // ====================================================================

  static Future<List<Song>> fetchSongsFromAlbumID(int idAlbum) async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/songs/album/$idAlbum"));
      if(response.statusCode==200){
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Song.fromJson(json)).toList();
      }else{
        throw Exception("Lổi tải dữ liệu");
      }
    }catch(e){
      throw Exception("Lối kết nối: $e");
    }
  }





  // ====================================================================

}
