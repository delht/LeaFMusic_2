import 'package:equatable/equatable.dart';
import 'package:leafmusic_2/models/song.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

// Trạng thái ban đầu
class SongInitial extends SongState {}

// Trạng thái đang tải dữ liệu
class SongLoading extends SongState {}

// Trạng thái khi tải thành công
class SongLoaded extends SongState {
  final List<Song> songs;

  const SongLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

// Trạng thái lỗi
class SongError extends SongState {
  final String message; // Thêm tham số message để hiển thị lỗi

  const SongError(this.message);

  @override
  List<Object> get props => [message];
}