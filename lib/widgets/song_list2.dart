import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/song/song_bloc.dart';
import '../bloc/song/song_event.dart';
import '../bloc/song/song_state.dart';
import '../models/song.dart';

class SongList2 extends StatelessWidget {
  final List<Song>? songs;
  final SongEvent? event;

  const SongList2({super.key, this.songs, this.event});

  Widget _buildSongTile(BuildContext context, Song song) {
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
        // TODO: xử lý khi bấm vào bài hát
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
            await songRepo.deleteSongFromFavorite(song.idSong);

            final prefs = await SharedPreferences.getInstance();
            final userId = prefs.getString('userId');
            if (userId != null) {
              context.read<SongBloc>().add(LoadSongsFromFavorite(userId));
            }

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

    ///TRUYỀN DỮ LIỆU THEO DANH SÁCH
    if (songs != null) {
      if (songs!.isEmpty) {
        return Center(child: Text("Không có bài hát nào"));
      }

      return ListView.builder(
        itemCount: songs!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildSongTile(context, songs![index]),
      );
    }

    ///TRUYỀN DỮ LIỆU THEO EVENT
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
            itemBuilder: (context, index) => _buildSongTile(context, loadedSongs[index]),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
