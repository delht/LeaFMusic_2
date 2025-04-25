import 'package:equatable/equatable.dart';
import 'package:leafmusic_2/models/song.dart';

abstract class SuggestState extends Equatable {
  const SuggestState();

  @override
  List<Object> get props => [];
}

// Trạng thái ban đầu
class SuggestInitial extends SuggestState {}

// Trạng thái đang tải dữ liệu
class SuggestLoading extends SuggestState {}

// Trạng thái khi tải thành công
class SuggestLoaded extends SuggestState {
  final List<Song> songs;

  const SuggestLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

// Trạng thái lỗi
class SuggestError extends SuggestState {
  final String message; // Thêm tham số message để hiển thị lỗi

  const SuggestError(this.message);

  @override
  List<Object> get props => [message];
}