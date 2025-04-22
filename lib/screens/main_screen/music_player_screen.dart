import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/customlist.dart';
import '../../models/song.dart';
import '../../repositories/customlist_repository.dart';
import '../../repositories/song_repository.dart';
import '../../repositories/artist_repository.dart'; // Thêm dòng này
import '../../models/artist.dart'; // Thêm dòng này

class MusicPlayerScreen extends StatefulWidget {

  final List<Song> songs; ///Danh sách bài hát truyền vào
  final int initialIndex; ///Vị trí song được chọn

  const MusicPlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

//==============================================================================
//==============================================================================

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _isLooping = false;
  bool _isFavorite = false; ///Biến để check xem bài hát đó có trong ds love hay chưa

  final SongRepository _songRepository = SongRepository();
  final ArtistRepository _artistRepository = ArtistRepository();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String? _artistName;

  Song get currentSong => widget.songs[_currentIndex];

  ///Tạo player phát nhạc
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _setupPlayer();
    _playCurrentSong();
  }

  ///============================== Xử lý các sự kiện khi hát
  void _setupPlayer() {

    _audioPlayer.onDurationChanged.listen((d) { setState(() => _duration = d); }); ///Thời lượng thay đổi thì cập nhật

    _audioPlayer.onPositionChanged.listen((p) { setState(() => _position = p); }); ///Vị trí phát thay đổi thì cập nhật

    _audioPlayer.onPlayerComplete.listen((event) { ///Nếu hết bài
      if (_isLooping) { //có thì lặp lại
        _playCurrentSong();
      } else { //ko thì phát tiếp
        _playNext();
      }
    });
  }

  ///============================== Phat bai hat hien tại
  Future<void> _playCurrentSong() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(currentSong.fileUrl));
    setState(() => _isPlaying = true);
    await _checkIfFavorite();
    await _loadArtistName(); // Gọi để hiển thị tên ca si
  }

  Future<void> _loadArtistName() async {
    try {
      final artist = await _artistRepository.fetchArtistsInfor(currentSong.idArtist);
      setState(() {
        _artistName = artist.name;
      });
    } catch (e) {
      setState(() {
        _artistName = 'Không rõ';
      });
    }
  }

  ///================================ Kiểm tra bài hát đó có trong danh sách yêu thích chưa để set trái tim

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return;

    try {
      final favoriteSongs = await _songRepository.fetchSongsFromFavorite(userId);
      final exists = favoriteSongs.any((song) => song.idSong == currentSong.idSong);
      setState(() => _isFavorite = exists);
    } catch (_) {
      setState(() => _isFavorite = false);
    }
  }

  ///===========================================================================
  /// Mấy cái nút

  /// Play - Páue
  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  ///Vòng lặp
  void _toggleLoop() {
    setState(() => _isLooping = !_isLooping);
  }

  // ==========================================
  ///Thêm xóa bài hát vào yêu thích
  void _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _songRepository.deleteSongFromFavorite(currentSong.idSong);
        setState(() => _isFavorite = false);
      } else {
        await _songRepository.addSongToFavorite(currentSong.idSong);
        setState(() => _isFavorite = true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }
  // ==========================================

  ///Chuyển tiếp - lùyi
  void _playNext() {
    if (_currentIndex < widget.songs.length - 1) {
      _currentIndex++;
      _playCurrentSong();
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _playCurrentSong();
    }
  }

  ///Nếu thóoát thì xóa bộ nhớ phát nhạc để tránh tràn bộ nhớ
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Chỉnh thời gian giây thành phút
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  ///===========================================================================
  ///===========================================================================
  ///===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( title: Text(currentSong.name),),

      appBar: AppBar(
        title: Text(currentSong.name),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            ///Hình của bài nhạc
            ClipOval(
              child: Image.network(
                currentSong.imageUrl,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/default_song_image.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            ///Thông tin bài nhạc
            Text(currentSong.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Ca sĩ: ${_artistName ?? 'Đang tải...'}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            Text("Phát hành: ${currentSong.formattedReleaseDate}", style: const TextStyle(fontSize: 16, color: Colors.grey)),

            ///Cái thanh thời gian
            Slider(
              value: _position.inSeconds.toDouble(), ///Time hiện tại
              min: 0,
              max: _duration.inSeconds.toDouble(), ///Tổng time bài hát
              onChanged: (value) { ///Chuyn nhạc đên thời gian tương ứng
                final position = Duration(seconds: value.toInt());
                _audioPlayer.seek(position);
              },
            ),
            Row( ///Giá trị thời gian đầu cuoois - Chỉ hiện để user nhận biết
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),

            ///Mấy cái nút
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                IconButton(
                  icon: Icon(
                    _isLooping ? Icons.repeat_one : Icons.repeat,
                    color: _isLooping ? Colors.blue : Colors.grey,
                  ),
                  onPressed: _toggleLoop,
                ),

                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 36,
                  onPressed: _playPrevious,
                ),

                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                  iconSize: 64,
                  onPressed: _togglePlayPause,
                ),

                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 36,
                  onPressed: _playNext,
                ),

                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                    IconButton(
                      icon: const Icon(Icons.playlist_add),
                      onPressed: _showAddToCustomListDialog,
                    ),
                  ],
                ),


              ],

            ),


          ],


        ),
      ),
    );
  }

  ///===========================================================================

  Future<void> _showAddToCustomListDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return;

    final customListRepo = CustomListRepository();
    List<CustomList> lists = [];

    try {
      lists = await customListRepo.fetchCustomList(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      return;
    }

    // Khởi tạo Map: idList => có bài hát không
    Map<int, bool> selectionMap = {};
    try {
      for (final list in lists) {
        final exists = await customListRepo.checkSongInCustomList(list.idList, currentSong.idSong);
        selectionMap[list.idList] = exists;
      }
    } catch (_) {
      for (final list in lists) {
        selectionMap[list.idList] = false;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm vào danh sách"),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setState) {
                return ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    final isChecked = selectionMap[list.idList] ?? false;
                    return CheckboxListTile(
                      title: Text(list.name),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          selectionMap[list.idList] = value ?? false;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Lưu"),
              onPressed: () async {
                for (final entry in selectionMap.entries) {
                  final idList = entry.key;
                  final shouldHave = entry.value;
                  final alreadyInList = await customListRepo.checkSongInCustomList(idList, currentSong.idSong);

                  if (shouldHave && !alreadyInList) {
                    await customListRepo.addSongToCustomList(idList, currentSong.idSong);
                  } else if (!shouldHave && alreadyInList) {
                    await customListRepo.removeSongFromCustomList(idList, currentSong.idSong);
                  }
                }

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật danh sách thành công")));
              },
            ),
          ],
        );
      },
    );
  }



}
