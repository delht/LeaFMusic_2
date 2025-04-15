import 'album.dart';
import 'artist.dart';
import 'song.dart';

class SearchResult {
  final List<Song> songs;
  final List<Artist> artists;
  final List<Album> albums;

  SearchResult({required this.songs, required this.artists, required this.albums});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      songs: (json['songs'] as List).map((e) => Song.fromJson(e)).toList(),
      artists: (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
      albums: (json['albums'] as List).map((e) => Album.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'SearchResult(songs: $songs, artists: $artists, albums: $albums)';
  }
}
