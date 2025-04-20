import 'package:leafmusic_2/models/genre.dart';

import 'album.dart';
import 'artist.dart';
import 'song.dart';

class SearchResult2 {
  final List<Song> songs;
  final List<Artist> artists;
  final List<Album> albums;
  final List<Genre> genres;

  SearchResult2({required this.songs, required this.artists, required this.albums, required this.genres});

  factory SearchResult2.fromJson(Map<String, dynamic> json) {
    return SearchResult2(
      songs: (json['songs'] as List).map((e) => Song.fromJson(e)).toList(),
      artists: (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
      albums: (json['albums'] as List).map((e) => Album.fromJson(e)).toList(),
      genres: (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'SearchResult(songs: $songs, artists: $artists, albums: $albums, genres: $genres)';
  }
}
