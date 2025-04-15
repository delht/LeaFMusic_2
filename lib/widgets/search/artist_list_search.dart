import 'package:flutter/material.dart';
import 'package:leafmusic_2/screens/details/artist_detail_screen.dart';
import '../../models/artist.dart';

class ArtistListSearch extends StatelessWidget {
  final List<Artist>? artists;

  const ArtistListSearch({super.key, this.artists});

  Widget _buildArtistTile(BuildContext context, Artist artist) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          artist.imageUrl,
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
      title: Text(artist.name),
      subtitle: Text("ID: ${artist.idArtist}"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(artist: artist),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (artists == null || artists!.isEmpty) {
      return const Center(child: Text("Không có nghệ sĩ nào"));
    }

    return ListView.builder(
      itemCount: artists!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildArtistTile(context, artists![index]),
    );
  }
}
