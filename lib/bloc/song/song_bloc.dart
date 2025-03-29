import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/bloc/song/song_state.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;

  SongBloc(this.songRepository) : super(SongInitial()) {
    on<LoadSongs>((event, emit) async {
      emit(SongLoading());
      try {
        final songs = await songRepository.fetchSongs();
        emit(SongLoaded(songs));
      } catch (error) {
        emit(SongError(error.toString())); // Truyền thông báo lỗi vào SongError
      }
    });
  }
}
