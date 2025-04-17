import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/song/song_bloc.dart';
import '../bloc/song/song_event.dart';
import '../bloc/song/song_state.dart';
import '../models/song.dart';
import '../screens/main_screen/music_player_screen.dart';

class SongList extends StatelessWidget {
  final List<Song>? songs;
  final SongEvent? event;

  const SongList({super.key, this.songs, this.event});

  Widget _buildSongTile(BuildContext context, Song song, int index, List<Song> songList) {
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
      subtitle: Text("Nghệ sĩ ${song.idArtist}"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MusicPlayerScreen(
              songs: songList,
              initialIndex: index,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// TRUYỀN DỮ LIỆU THEO DANH SÁCH CÓ SẴN
    if (songs != null) {
      if (songs!.isEmpty) {
        return Center(child: Text("Không có bài hát nào"));
      }

      return ListView.builder(
        itemCount: songs!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildSongTile(context, songs![index], index, songs!),
      );
    }

    /// TRUYỀN DỮ LIỆU THEO EVENT (BLOC)
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
            return Center(child: Text("Không có bài hát nào"));
          }

          return ListView.builder(
            itemCount: loadedSongs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildSongTile(context, loadedSongs[index], index, loadedSongs),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
