import 'package:equatable/equatable.dart';

abstract class CustomlistEvent extends Equatable {
  const CustomlistEvent();

  @override
  List<Object> get props => [];
}

// =================================================================

class LoadCustomlists extends CustomlistEvent{
  final String id_user;
  const LoadCustomlists(this.id_user);

  @override
  List<Object> get props => [id_user];
}

class AddCustomList extends CustomlistEvent {
  final String name;
  final String idUser;

  const AddCustomList({required this.name, required this.idUser});

  @override
  List<Object> get props => [name, idUser];
}

class UpdateCustomList extends CustomlistEvent {
  final int idList;
  final String newName;
  final String idUser;

  const UpdateCustomList({required this.idList, required this.newName, required this.idUser});

  @override
  List<Object> get props => [idList, newName, idUser];
}

class DeleteCustomList extends CustomlistEvent {
  final int idList;
  final String idUser;

  const DeleteCustomList({required this.idList, required this.idUser});

  @override
  List<Object> get props => [idList, idUser];
}


// ====================================================================

class LoadCustomlistsPublic extends CustomlistEvent {}

