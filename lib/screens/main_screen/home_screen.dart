import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_bloc.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/widgets/artist_list.dart';
import 'package:leafmusic_2/widgets/song_list.dart';
import 'package:leafmusic_2/widgets/album_list.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/bloc/album/album_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_event.dart';
import 'package:leafmusic_2/bloc/artist/artist_bloc.dart';
import 'package:leafmusic_2/bloc/artist/artist_event.dart';
import 'package:leafmusic_2/bloc/suggest/suggest_event.dart';
import 'package:leafmusic_2/widgets/section_title.dart';
import 'package:leafmusic_2/widgets/song_list4.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> _recentArtistIds = [];
  List<int> _recentGenreIds = [];

  @override
  void initState() {
    super.initState();
    _loadRecentIds();
  }

  Future<void> _loadRecentIds() async {
    final prefs = await SharedPreferences.getInstance();
    final artistIds = prefs.getStringList('recent_artist_ids') ?? [];
    final genreIds = prefs.getStringList('recent_genre_ids') ?? [];

    final parsedArtistIds = artistIds.map(int.parse).toList();
    final parsedGenreIds = genreIds.map(int.parse).toList();

    setState(() {
      _recentArtistIds = parsedArtistIds;
      _recentGenreIds = parsedGenreIds;
    });

    print('\x1B[32mID ca sĩ gần đây: $_recentArtistIds\x1B[0m');
    print('\x1B[32mID thể loại gần đây: $_recentGenreIds\x1B[0m');

    // Gọi SuggestBloc tại đây sau khi load xong
    context.read<SuggestBloc>().add(LoadSuggestedSongs(
      artistIds: parsedArtistIds,
      genreIds: parsedGenreIds,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitConfirmation(context),
      child: MainLayout(
        title: "Trang chủ",
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<SongBloc>().add(LoadSongs());
            context.read<AlbumBloc>().add(LoadAlbums());
            context.read<ArtistBloc>().add(LoadArtists());
            context.read<SuggestBloc>().add(LoadSuggestedSongs(artistIds: _recentArtistIds, genreIds: _recentGenreIds,));
            await _loadRecentIds();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SectionTitle(title: "Bài hát đề xuất"),
                SongList4(event: LoadSuggestedSongs(artistIds: _recentArtistIds, genreIds: _recentGenreIds,)),

                SectionTitle(title: "Bài hát ngẫu nhiên"),
                SongList(event: LoadSongs()),

                const SizedBox(height: 10),
                SectionTitle(title: "Album đề xuất"),
                AlbumList(event: LoadAlbums()),

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
