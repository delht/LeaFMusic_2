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
    on<LoadSongsFromFavorite>(_onLoadSongsFromFavorite);
    on<LoadSongsFromCustomList>(_onLoadSongsFromCustomList);
  }


  // ============================================================================
  ///emit(xxx): thông báo trạng thái cho UI
  ///UI gọi → Bloc nhận event → gọi repository → trả dữ liệu hoặc lỗi → UI nhận state và hiển thị

  void _onLoadSongs(LoadSongs event, Emitter<SongState> emit) async { ///Đăng ký sự kiện
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongsRandom(); ///Lấy data từ api repo
      emit(SongLoaded(songs)); ///Trả data về giao diện thông qua trạng thái
    } catch (e) {
      emit(SongError("Lấy dữ liệu bài hát random thất bại")); ///Lỗi
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
      final songs = await songRepository.fetchSongsByAlbum(event.id_album);
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Tải danh sách bài hát của ca sĩ thất bại"));
    }
  }


  void _onLoadSongsFromFavorite(LoadSongsFromFavorite event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongsFromFavorite(event.id_user);
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Tải danh sách bài hát thất bại"));
    }
  }


  void _onLoadSongsFromCustomList(LoadSongsFromCustomList event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongsFromCustomList(event.id_list);
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError("Tải danh sách bài hát thất bại"));
    }
  }

// =========================================================================================================






}

