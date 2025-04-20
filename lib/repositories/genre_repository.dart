import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:leafmusic_2/models/genre.dart';

class GenreRepository{

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";
  
  Future<List<Genre>> fetchGenres() async {
    final response = await http.get(Uri.parse('http://$ip/api/genres/all'));

    if (response.statusCode == 200){
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Genre.fromJson(json)).toList();
    }else{
      throw Exception("Không thể tải thể loại");
    }
  }

  Future<List<Genre>> fetchSongsByGenres(int id) async {
    final response = await http.get(Uri.parse('http://$ip/api/songs/genre/$id'));

    if (response.statusCode == 200){
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Genre.fromJson(json)).toList();
    }else{
      throw Exception("Không thể tải bài hát theo thể loại");
    }
  }



  
}