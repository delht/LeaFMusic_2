import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/song_repository.dart';
import 'song_event.dart';
import 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;

  SongBloc({required this.songRepository}) : super(SongInitial()) {
    on<LoadSongs>(_onLoadSongs);
    on<LoadTop5SongsByArtist>(_onLoadSongsByArtist);
    on<LoadSongsByAlbum>(_onLoadSongsByAlbum);

  }

  void _onLoadSongs(LoadSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongsRandom();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Lấy dữ liệu bài hát random thất bại"));
    }
  }

  void _onLoadSongsByArtist(LoadTop5SongsByArtist event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchTop5SongByArtist(event.id_artist);
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Failed to load songs by artist"));
    }
  }

  void _onLoadSongsByAlbum(LoadSongsByAlbum event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchTop5SongByArtist(event.id_album);
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Failed to load songs by artist"));
    }
  }



}

