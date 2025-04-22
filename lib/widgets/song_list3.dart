import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/customlist/customlist_event.dart';
import '../bloc/song/song_bloc.dart';
import '../bloc/song/song_event.dart';
import '../bloc/song/song_state.dart';
import '../models/artist.dart';
import '../models/song.dart';
import '../repositories/artist_repository.dart';
import '../screens/main_screen/music_player_screen.dart';

class SongList3 extends StatelessWidget {
  final List<Song>? songs;
  final SongEvent? event;
  final int? idList;

  const SongList3({super.key, this.songs, this.event, this.idList});

  Widget _buildSongTile(BuildContext context, Song song, List<Song> songsToPlay) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          song.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/default_song_image.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(song.name),

      subtitle: FutureBuilder<Artist>(
        future: ArtistRepository().fetchArtistsInfor(song.idArtist),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Đang tải nghệ sĩ...");
          } else if (snapshot.hasError) {
            return const Text("Không thể tải nghệ sĩ");
          } else {
            final artist = snapshot.data!;
            return Text("${artist.name}");
          }
        },
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

      onTap: () {
        final index = songsToPlay.indexWhere((s) => s.idSong == song.idSong);
        if (index != -1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MusicPlayerScreen(
                songs: songsToPlay,
                initialIndex: index,
              ),
            ),
          );
        }
      },

      onLongPress: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Xác nhận"),
            content: const Text("Bạn có muốn xóa bài hát này khỏi danh sách yêu thích?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Hủy"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Xóa", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            final songRepo = context.read<SongBloc>().songRepository;
            await songRepo.removeSongFromCustomList(idList!, song.idSong);

            context.read<SongBloc>().add(LoadSongsFromCustomList(idList!));


            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đã xóa bài hát khỏi danh sách yêu thích")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi khi xóa: $e")),
            );
          }
        }


      },


    );
  }

  @override
  Widget build(BuildContext context) {
    /// TRƯỜNG HỢP: Đã truyền sẵn danh sách songs
    if (songs != null) {
      if (songs!.isEmpty) {
        return const Center(child: Text("Không có bài hát nào"));
      }

      return ListView.builder(
        itemCount: songs!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            _buildSongTile(context, songs![index], songs!),
      );
    }

    /// TRƯỜNG HỢP: Lấy danh sách từ Bloc theo event
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongInitial) {
          context.read<SongBloc>().add(event!);
          return const Center(child: CircularProgressIndicator());
        } else if (state is SongLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SongError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        } else if (state is SongLoaded) {
          final loadedSongs = state.songs;

          if (loadedSongs.isEmpty) {
            return const Center(child: Text("Không có bài hát nào"));
          }

          return ListView.builder(
            itemCount: loadedSongs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                _buildSongTile(context, loadedSongs[index], loadedSongs),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
