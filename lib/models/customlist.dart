class CustomList {
  final int idList;
  final String name;
  final String idUser;

  const CustomList({
    required this.idList,
    required this.name,
    required this.idUser
  });

  factory CustomList.fromJson(Map<String, dynamic> json) {
    return CustomList(
      idList: json['idList'] ?? 0,
      name: json['name'] ?? "No data",
      idUser: json['idUser'] ?? "No data",
    );
  }

}