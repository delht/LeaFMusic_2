import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/widgets/search/album_list_search.dart';
import 'package:leafmusic_2/widgets/song_list.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../widgets/search/artist_list_search.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/home');
          return false;
        },

        child: MainLayout(
        title: 'Tìm kiếm',
        body: Column(
          children: [

            /// Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(

                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Nhập từ khóa tìm kiếm...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),

                    ///=========================================================

                    onPressed: () {
                      context
                          .read<SearchBloc>()
                          .add(LoadSearch(keyword: _searchController.text));
                    },

                    ///=========================================================

                  ),
                ),

                ///Giá trị gõ vào sẽ đuowjc đem đi truy vấn data
                onChanged: (query) {
                  context.read<SearchBloc>().add(LoadSearch(keyword: query));
                },

              ),
            ),

            /// Kết quả tìm kiếm
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {

                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());

                  } else if (state is SearchLoaded) {

                    var songs = state.result.songs;
                    var artists = state.result.artists;
                    var albums = state.result.albums;

                    if (songs.isEmpty && artists.isEmpty && albums.isEmpty) {
                      return const Center(child: Text('Không tìm thấy kết quả phù hợp.'));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Songs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SongList(songs: songs),

                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Artists", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          ArtistListSearch(artists: artists),

                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Albums", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          AlbumListSearch(albums: albums),

                        ],
                      ),
                    );

                  } else if (state is SearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('Không có kết quả'));
                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
