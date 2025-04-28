import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumByArtist>(_onLoadAlbumsByArtist);
  }

  void _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.fetchAlbums();
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError("Không thể tải album"));
    }
  }

  void _onLoadAlbumsByArtist(LoadAlbumByArtist event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.fetchAlbumsByArtist(event.id_artist);
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError("Không thể tải album"));
    }
  }


}

