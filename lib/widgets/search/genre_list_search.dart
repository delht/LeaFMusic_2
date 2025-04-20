import 'package:flutter/material.dart';
import 'package:leafmusic_2/models/genre.dart';
import 'package:leafmusic_2/screens/details/artist_detail_screen.dart';
import 'package:leafmusic_2/screens/main_screen/home_screen.dart';
import '../../models/artist.dart';

class GenreListSearch extends StatelessWidget {
  final List<Genre>? genres;

  const GenreListSearch({super.key, this.genres});

  Widget _buildGenreTile(BuildContext context, Genre genre) {
    return ListTile(
      title: Text(genre.name),
      // subtitle: Text("ID: ${artist.idArtist}"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => ArtistDetailScreen(artist: genre),
            builder: (context) => HomeScreen(),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (genres == null || genres!.isEmpty) {
      return const Center(child: Text("Không có thể loại nào"));
    }

    return ListView.builder(
      itemCount: genres!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildGenreTile(context, genres![index]),
    );
  }
}
