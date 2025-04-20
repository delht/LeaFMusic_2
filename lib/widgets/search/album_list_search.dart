import 'package:flutter/material.dart';
import 'package:leafmusic_2/screens/details/album_detail_screen.dart';
import '../../models/album.dart';
import '../../screens/details/artist_detail_screen.dart';


class AlbumListSearch extends StatelessWidget {
  final List<Album>? albums;

  const AlbumListSearch({super.key, this.albums});

  Widget _buildAlbumTile(BuildContext context, Album album) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          album.imageUrl,
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
      title: Text(album.name),
      subtitle: Text("ID: ${album.idAlbum}"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(album: album),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (albums == null || albums!.isEmpty) {
      return const Center(child: Text("Không có album nào"));
    }

    return ListView.builder(
      itemCount: albums!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildAlbumTile(context, albums![index]), ///Dấu chaasm than để khi mà mảng có null thì vẫn được sử dụng chứ ko crack app
    );
  }

}
