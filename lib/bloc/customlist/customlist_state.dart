import 'package:equatable/equatable.dart';
import 'package:leafmusic_2/models/customlist.dart';
import 'package:leafmusic_2/models/song.dart';

abstract class CustomlistState extends Equatable {
  const CustomlistState();

  @override
  List<Object> get props => [];
}

// Trạng thái ban đầu
class CustomListInitial extends CustomlistState {}

// Trạng thái đang tải dữ liệu
class CustomListLoading extends CustomlistState {}

// Trạng thái khi tải thành công
class CustomListLoaded extends CustomlistState {
  final List<CustomList> customlist;

  const CustomListLoaded(this.customlist);

  @override
  List<Object> get props => [customlist];
}

// Trạng thái lỗi
class CustomListError extends CustomlistState {
  final String message;

  const CustomListError(this.message);

  @override
  List<Object> get props => [message];
}