import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) { // 🔥 Đổi từ AlbumLoading() thành AlbumInitial()
    on<LoadAlbums>(_onLoadAlbums);
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
}

