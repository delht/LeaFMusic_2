import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/song_repository.dart';
import 'song_event.dart';
import 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;

  SongBloc({required this.songRepository}) : super(SongInitial()) {
    on<LoadSongs>(_onLoadSongs);
  }

  void _onLoadSongs(LoadSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongs();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Failed to load songs"));
    }
  }
}
