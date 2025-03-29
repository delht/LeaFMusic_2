import 'package:equatable/equatable.dart';
import '../../models/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

// Trạng thái ban đầu
class AlbumInitial extends AlbumState {}

// Trạng thái đang tải dữ liệu
class AlbumLoading extends AlbumState {}

// Trạng thái khi tải thành công
class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  const AlbumLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

// Trạng thái lỗi
class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object> get props => [message];
}
