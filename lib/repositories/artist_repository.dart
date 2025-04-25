
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:leafmusic_2/models/artist.dart';
import 'package:leafmusic_2/models/genre.dart';

class ArtistRepository{
  // final String apiUrl = "http://${dotenv.env['IPv4']}:8080/api/artists/random";

  final String ip = "${dotenv.env['IPv4']}:${dotenv.env['port']}";

  Future<List<Artist>> fetchArtists() async {
    final response = await http.get(Uri.parse("http://$ip/api/artists/random"));

    if (response.statusCode == 200){
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Artist.fromJson(json)).toList();
    }else{
      throw Exception("Không thể tải ca sĩ");
    }
  }

  Future<Artist> fetchArtistsInfor(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/artists/$id"));

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Artist.fromJson(data);
    } else {
      throw Exception('Failed to load artist');
    }
  }


  ///==========================================================================
  /// Để ké

  Future<Genre> fetchGenresInfor(int id) async {
    final response = await http.get(Uri.parse("http://$ip/api/genres/$id"));

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Genre.fromJson(data);
    } else {
      throw Exception('Failed to load genre');
    }
  }


}