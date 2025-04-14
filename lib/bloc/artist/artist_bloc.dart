import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/artist_repository.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistRepository artistRepository;

  ArtistBloc({required this.artistRepository}) : super(ArtistInitial()) {
    on<LoadArtists>(_onloadArtists);
  }

  void _onloadArtists(LoadArtists event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    try {
      final artists = await artistRepository.fetchArtists();
      emit(ArtistLoaded(artists));
    } catch (e) {
      emit(ArtistError("Không thể tải ca sĩ"));
    }
  }
}