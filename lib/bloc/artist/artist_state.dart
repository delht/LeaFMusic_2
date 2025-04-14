import 'package:equatable/equatable.dart';
import '../../models/artist.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();

  @override
  List<Object> get props => [];
}

// Trạng thái ban đầu
class ArtistInitial extends ArtistState {}

// Trạng thái đang tải dữ liệu
class ArtistLoading extends ArtistState {}

// Trạng thái khi tải thành công
class ArtistLoaded extends ArtistState {
  final List<Artist> artists;

  const ArtistLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

// Trạng thái lỗi
class ArtistError extends ArtistState {
  final String message; // Thêm tham số message để hiển thị lỗi

  const ArtistError(this.message);

  @override
  List<Object> get props => [message];
}