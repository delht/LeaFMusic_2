import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/song.dart';
import '../repositories/search_repository.dart';
import '../widgets/search_result_list.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return BlocProvider(
      create: (_) => SearchBloc(searchRepository: SearchRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: "Enter keyword"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final keyword = controller.text;
                      if (keyword.isNotEmpty) {
                        context.read<SearchBloc>().add(LoadSearch(keyword: keyword));
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    if (state.isEmpty) {
                      return const Center(child: Text("No search results found."));
                    }

                    return ListView(
                      children: [
                        if (state.result.songs.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Songs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          SearchResultList<Song>(
                            result: state.result.songs,
                            itemBuilder: (song) => ListTile(
                              title: Text(song.name),
                              subtitle: Text(song.name),
                            ),
                          ),
                        ],
                        if (state.result.albums.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Albums", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          SearchResultList<Album>(
                            result: state.result.albums,
                            itemBuilder: (album) => ListTile(
                              title: Text(album.name),
                              subtitle: Text(album.name),
                            ),
                          ),
                        ],
                        if (state.result.artists.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Artists", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          SearchResultList<Artist>(
                            result: state.result.artists,
                            itemBuilder: (artist) => ListTile(
                              title: Text(artist.name),
                            ),
                          ),
                        ],
                      ],
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("Enter a keyword to search"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
