import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_bloc.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_state.dart';

import '../bloc/song/song_bloc.dart';
import '../bloc/song/song_event.dart';
import '../bloc/song/song_state.dart';
import '../bloc/suggest/suggest_event.dart';
import '../models/artist.dart';
import '../models/genre.dart';
import '../models/song.dart';
import '../repositories/artist_repository.dart';
import '../repositories/song_repository.dart';
import '../screens/main_screen/music_player_screen.dart';

class SongList4 extends StatelessWidget {

  final List<Song>? songs; ///Dùng nếu có sẵn danh sách bài hát
  final SuggestEvent? event; ///Nếu nếu truyền sự kiện

  const SongList4({super.key, this.songs, this.event});

  Widget _buildSongTile(BuildContext context, Song song, int index, List<Song> SongList4) {

    return ListTile(

      //Hình bên hông
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

      //Hiển thị tên ca sĩ thay vì id
      subtitle: FutureBuilder<Artist>(

        future: ArtistRepository().fetchArtistsInfor(song.idArtist),
        builder: (context, snapshotArtist) {
          if (snapshotArtist.connectionState == ConnectionState.waiting) {
            return const Text("Đang tải...");
          } else if (snapshotArtist.hasError) {
            return const Text("Lỗi tải ca sĩ");
          } else {



            final artist = snapshotArtist.data!;
            return FutureBuilder<Genre>(
              future: ArtistRepository().fetchGenresInfor(song.idGenre),
              builder: (context, snapshotGenre) {



                if (snapshotGenre.connectionState == ConnectionState.waiting) {
                  return Text("${artist.name} · Đang tải thể loại...");
                } else if (snapshotGenre.hasError) {
                  return Text("${artist.name} · Lỗi thể loại");
                } else {

                  final genre = snapshotGenre.data!;
                  // return Text("${artist.name} --- ${genre.name}");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tác giả: ${artist.name}"),
                      Text("Thể loại: ${genre.name}"),
                    ],
                  );



                }



              },



            );


          }


        },



      ),


      //Mũi tên bên phải
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),


      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MusicPlayerScreen(
              songs: SongList4,
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
    return BlocBuilder<SuggestBloc, SuggestState>(
      builder: (context, state) {

        if (state is SuggestInitial) {
          context.read<SuggestBloc>().add(event!); ///Lấy data từ sự kiện
          return const Center(child: CircularProgressIndicator());
        } else if (state is SuggestLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SuggestError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        } else if (state is SuggestLoaded) {
          final loadedSongs = state.songs;

          if (loadedSongs.isEmpty) {
            // return Center(child: Text("Không có bài hát nào"));
            /// Nếu rỗng thì dùng, thường cho lần đầu đăng nhập chưa có prefs
            return FutureBuilder<List<Song>>(
              future: SongRepository().fetchSongsRandom(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi khi tải bài hát ngẫu nhiên"));
                } else {
                  final randomSongs = snapshot.data!;
                  return ListView.builder(
                    itemCount: randomSongs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        _buildSongTile(context, randomSongs[index], index, randomSongs),
                  );
                }
              },
            );
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
