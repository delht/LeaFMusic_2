import 'package:equatable/equatable.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

// Sự kiện để tải danh sách bài hát
class LoadSongs extends SongEvent {}
