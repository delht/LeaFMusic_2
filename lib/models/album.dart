class Album {
  final int idAlbum;
  final String name;
  final String imageUrl;
  final DateTime releaseDate;
  final int idArtist;

  const Album({
    required this.idAlbum,
    required this.name,
    required this.imageUrl,
    required this.releaseDate,
    required this.idArtist,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      idAlbum: json['idAlbum'] ?? 0,
      name: json['name'] ?? "No data",
      imageUrl: json['imageUrl'] ?? "No data",
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : DateTime(2000, 1, 1),
      idArtist: json['idArtist'] ?? "No data",
    );
  }

  @override
  String toString() {
    return "Album(idAlbum: $idAlbum, )";
  }

}
