import 'package:equatable/equatable.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

// =============================================================================
///Mồi class đại diện cho cho hành động của user hay của app
///Khi được gọi: context.read<SongBloc>().add(LoadSongs());

class LoadSongs extends SongEvent {

} //RANDOM

class LoadTop5SongsByArtist extends SongEvent{
  final int id_artist;
  const LoadTop5SongsByArtist(this.id_artist);

  @override
  List<Object> get props => [id_artist];
}

class LoadSongsByAlbum extends SongEvent{
  final int id_album;
  const LoadSongsByAlbum(this.id_album);

  @override
  List<Object> get props => [id_album];
}

class LoadSongsFromFavorite extends SongEvent{
  final String id_user;
  const LoadSongsFromFavorite(this.id_user);

  @override
  List<Object> get props => [id_user];
}


