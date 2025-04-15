import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Gửi sự kiện tìm kiếm với từ khóa nhập vào
              context.read<SearchBloc>().add(LoadSearch(keyword: _searchController.text));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for songs, artists, albums...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                // Gửi sự kiện tìm kiếm ngay khi người dùng thay đổi từ khóa
                context.read<SearchBloc>().add(LoadSearch(keyword: query));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          // Nếu đang tải dữ liệu
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Nếu có dữ liệu tìm được
          else if (state is SearchLoaded) {
            var songs = state.result.songs;
            var artists = state.result.artists;
            var albums = state.result.albums;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Hiển thị bài hát
                  Text(
                    "Songs",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      var song = songs[index];
                      return ListTile(
                        title: Text(song.name),  // Hiển thị tên bài hát
                      );
                    },
                  ),

                  // Hiển thị nghệ sĩ
                  Text(
                    "Artists",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      var artist = artists[index];
                      return ListTile(
                        title: Text('Artist ID: ${artist.idArtist}'),  // Hiển thị ID của nghệ sĩ
                      );
                    },
                  ),

                  // Hiển thị album
                  Text(
                    "Albums",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      var album = albums[index];
                      return ListTile(
                        title: Text('Album ID: ${album.idAlbum}'),  // Hiển thị ID của album
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // Nếu có lỗi khi tìm kiếm
          else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // Trường hợp không có kết quả
          else {
            return Center(child: Text('No results found'));
          }
        },
      ),
    );
  }
}
