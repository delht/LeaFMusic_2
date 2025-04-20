import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/widgets/artist_list.dart';
import 'package:leafmusic_2/widgets/song_list.dart';
import 'package:leafmusic_2/widgets/album_list.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/bloc/song/song_state.dart';
import 'package:leafmusic_2/bloc/album/album_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_event.dart';
import 'package:leafmusic_2/bloc/album/album_state.dart';

import '../../bloc/artist/artist_bloc.dart';
import '../../bloc/artist/artist_event.dart';
import '../../widgets/section_title.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitConfirmation(context), //chặn thoát màn hình khi bấm quay lại (chỉ có ở home)

      child: MainLayout(

        title: "Trang chủ",
        body: RefreshIndicator(

          onRefresh: () async {
            context.read<SongBloc>().add(LoadSongs()); // Load danh sách bài hát
            context.read<AlbumBloc>().add(LoadAlbums()); // Load danh sách album
            context.read<ArtistBloc>().add(LoadArtists()); // Load danh sách nghệ sĩ
          },

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SectionTitle(title: "Bài hát đề xuất"),
                SongList(event: LoadSongs()), // Hiển thị danh sách bài hát

                const SizedBox(height: 10),
                SectionTitle(title: "Album đề xuất"),
                AlbumList(event: LoadAlbums(),),

                const SizedBox(height: 10),
                SectionTitle(title: "Ca sĩ đề xuất"),
                const ArtistList(),

              ],
            ),
          ),
        ),
      ),


    );

  }

  ///Xử lý khi bấm back
  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận thoát"),
        content: const Text("Bạn có chắc chắn muốn thoát ứng dụng không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Có"),
          ),
        ],
      ),
    ) ??
        false;
  }


}
