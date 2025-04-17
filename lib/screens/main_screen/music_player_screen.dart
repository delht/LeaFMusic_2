import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/song.dart';
import '../../repositories/song_repository.dart';
import '../../repositories/artist_repository.dart'; // Thêm dòng này
import '../../models/artist.dart'; // Thêm dòng này

class MusicPlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;

  const MusicPlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _isLooping = false;
  bool _isFavorite = false;

  final SongRepository _songRepository = SongRepository();
  final ArtistRepository _artistRepository = ArtistRepository();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String? _artistName;

  Song get currentSong => widget.songs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _setupPlayer();
    _playCurrentSong();
  }

  void _setupPlayer() {
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isLooping) {
        _playCurrentSong();
      } else {
        _playNext();
      }
    });
  }

  Future<void> _playCurrentSong() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(currentSong.fileUrl));
    setState(() => _isPlaying = true);
    await _checkIfFavorite();
    await _loadArtistName(); // Gọi để hiển thị tên nghệ sĩ
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

  void _toggleLoop() {
    setState(() => _isLooping = !_isLooping);
  }

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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentSong.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
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
            Text(currentSong.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Nghệ sĩ: ${_artistName ?? 'Đang tải...'}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            Text("Phát hành: ${currentSong.formattedReleaseDate}", style: const TextStyle(fontSize: 16, color: Colors.grey)),

            Slider(
              value: _position.inSeconds.toDouble(),
              min: 0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                final position = Duration(seconds: value.toInt());
                _audioPlayer.seek(position);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),

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
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
