import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

// =============================================================================

class LoadAlbums extends AlbumEvent {}

class LoadAlbumByArtist extends AlbumEvent{
  final int id_artist;
  const LoadAlbumByArtist(this.id_artist);

  @override
  List<Object> get props => [id_artist];
}