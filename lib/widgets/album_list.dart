import 'package:flutter/material.dart';
import 'package:leafmusic_2/models/album.dart';
import 'package:leafmusic_2/screens/album_detail_screen.dart';

class AlbumList extends StatelessWidget {
  final List<Album> albums;

  const AlbumList({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length, // Hiển thị đúng số album
        padding: const EdgeInsets.symmetric(horizontal: 10),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _buildHorizontalItem(context, albums[index]);
        },
      ),
    );
  }

  Widget _buildHorizontalItem(BuildContext context, Album album) {
    return Material(
      color: Colors.transparent, // Không có nền mặc định
      child: InkWell(
        onTap: () {
          print("Bạn đã nhấn vào album: ${album.name}");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlbumDetailScreen(album: album),),
          );
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.blue.withOpacity(0.3),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  album.imageUrl,
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_song_image.png',
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: Text(
                  album.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
