import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/widgets/song_list3.dart';

import '../../bloc/song/song_bloc.dart';
import '../../bloc/song/song_event.dart';
import '../../bloc/song/song_state.dart';
import '../../custom/main_layout.dart';

class CustomListSongsScreen extends StatefulWidget {
  final int idList;
  final String name;

  const CustomListSongsScreen({
    super.key,
    required this.idList,
    required this.name,
  });

  @override
  State<CustomListSongsScreen> createState() => _CustomListSongsScreenState();
}

class _CustomListSongsScreenState extends State<CustomListSongsScreen> {
  late final SongBloc songBloc;

  @override
  void initState() {
    super.initState();
    songBloc = SongBloc(songRepository: SongRepository());
    songBloc.add(LoadSongsFromCustomList(widget.idList));
  }

  Future<void> _onRefresh() async {
    songBloc.add(LoadSongsFromCustomList(widget.idList));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: songBloc,
      child: MainLayout(
        title: widget.name,
        body: BlocBuilder<SongBloc, SongState>(
          builder: (context, state) {
            if (state is SongLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SongError) {
              return Center(child: Text("Lỗi: ${state.message}"));
            } else if (state is SongLoaded) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 70),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("[ Nhấn giữ để xoá bài hát khỏi danh sách ]", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          children: [
                            SongList3(
                              event: LoadSongsFromCustomList(widget.idList),
                              songs: state.songs,
                              idList: widget.idList, // để dùng cho việc xoá
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Danh sách sẽ được hiển thị ở đây"));
          },
        ),
      ),
    );
  }
}
