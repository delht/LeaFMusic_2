import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/widgets/song_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/song/song_bloc.dart';
import '../../bloc/song/song_event.dart';
import '../../bloc/song/song_state.dart';
import '../../custom/main_layout.dart';
import '../../widgets/song_list2.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  String? userId;
  late SongBloc songBloc;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    songBloc = SongBloc(songRepository: SongRepository());
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (id != null) {
      setState(() {
        userId = id;
      });
      songBloc.add(LoadSongsFromFavorite(id));
    }
  }

  Future<void> _onRefresh() async {
    // Gọi lại _loadUserId để reload danh sách yêu thích khi kéo xuống
    await _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: BlocProvider.value(
        value: songBloc,
        child: MainLayout(
          title: "Danh sách yêu thích",
          body: BlocBuilder<SongBloc, SongState>(
            builder: (context, state) {
              if (userId == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SongLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SongError) {
                return Center(child: Text("Lỗi: ${state.message}"));
              } else if (state is SongLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("[ Nhấn giữ để xoá bài hát khỏi danh sách yêu thích ]", style: TextStyle(fontSize: 16, color: Colors.grey),),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,  // Khi kéo xuống, gọi _onRefresh để reload
                          child: ListView(  // Đảm bảo rằng đây là một widget cuộn được
                            children: [
                              SongList2(event: LoadSongsFromFavorite(userId!)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("Danh sách yêu thích sẽ được hiển thị ở đây"));
            },
          ),
        ),
      ),
    );
  }
}
