class Genre {
  final int idGenre;
  final String name;

  const Genre({
    required this.idGenre,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      idGenre: json['idGenre'] ?? 0,
      name: json['name'] ?? "No data",
    );
  }

  @override
  String toString() {
    return "Genre(idGenre: $idGenre, )";
  }


}