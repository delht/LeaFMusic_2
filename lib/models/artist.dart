class Artist {
  final int idArtist;
  final String name;
  final String imageUrl;

  const Artist({
    required this.idArtist,
    required this.name,
    required this.imageUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      idArtist: json['idArtist'] ?? 0,
      name: json['name'] ?? "No data",
      imageUrl: json['imageUrl'] ?? "No data",
    );
  }
  
  @override
  String toString() {
    return "Artist(idArtist: $idArtist, )";
  }
  
}
