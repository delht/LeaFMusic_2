import 'package:flutter/material.dart';
import 'package:leafmusic_2/models/artist.dart';

class ArtistDetailScreen extends StatelessWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                artist.imageUrl,
                width: 250,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_song_image.png',
                    width: 250,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              artist.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Text(
            //   artist.bio ?? "Chưa có thông tin", // Thêm trường bio nếu có
            //   style: TextStyle(fontSize: 16),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
