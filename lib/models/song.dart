import 'package:intl/intl.dart';

class Song {
  final int idSong;
  final String name;
  final String imageUrl;
  final String fileUrl;
  final DateTime releaseDate;
  final int idArtist;
  final int idAlbum;
  final int idGenre;

  const Song({
    required this.idSong,
    required this.name,
    required this.imageUrl,
    required this.fileUrl,
    required this.releaseDate,
    required this.idArtist,
    required this.idAlbum,
    required this.idGenre,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      idSong: json['idSong'] ?? 0,
      name: json['name'] ?? "No data",
      imageUrl: json['imageUrl'] ?? "No data",
      fileUrl: json['fileUrl'] ?? "No data",
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : DateTime(2000, 1, 1),
      idArtist: json['idArtist'] ?? 0,
      idAlbum: json['idAlbum'] ?? 0,
      idGenre: json['idGenre'] ?? 0,
    );
  }

  String get formattedReleaseDate {
    return DateFormat('dd/MM/yyyy').format(releaseDate);
  }

  @override
  String toString() {
    return "Song(idSong: $idSong, name: $name, imageUrl: $imageUrl, fileUrl: $fileUrl, "
        "releaseDate: $releaseDate, idArtist: $idArtist, idAlbum: $idAlbum, idGenre: $idGenre)";
  }
}
