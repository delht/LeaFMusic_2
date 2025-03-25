import 'package:flutter/material.dart';
import 'package:leafmusic_2/models/song.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;

  const SongList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              song.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/default_song_image.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          title: Text(song.name),
          subtitle: Text("Nghệ sĩ ${song.idArtist}"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey,),

          onTap: () => null,

        );
      },
    );
  }
}
