import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_event.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_state.dart';
import '../../repositories/song_repository.dart';

class SuggestBloc extends Bloc<SuggestEvent, SuggestState> {
  final SongRepository songRepository;

  SuggestBloc({required this.songRepository}) : super(SuggestInitial()) {
    on<LoadSuggestedSongs>(_onLoadSuggestedSongs);
  }


  void _onLoadSuggestedSongs(LoadSuggestedSongs event, Emitter<SuggestState> emit) async {
    emit(SuggestLoading());
    try {
      final songs = await songRepository.fetchSuggestedSongs(
        artistIds: event.artistIds,
        genreIds: event.genreIds,
      );
      emit(SuggestLoaded(songs));
    } catch (e) {
      emit(SuggestError("Lấy bài hát đề xuất thất bại"));
    }
  }




}

