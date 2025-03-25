import 'package:flutter/material.dart';
import 'package:leafmusic_2/models/artist.dart';

class ArtistList extends StatelessWidget {
  final List<Artist> artists;

  const ArtistList({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _buildArtistItem(context, artists[index]);
        },
      ),
    );
  }

  Widget _buildArtistItem(BuildContext context, Artist artist) {
    return Material(
      color: Colors.transparent, // Đảm bảo không bị ảnh hưởng bởi màu nền của Material cha
      child: InkWell(
        onTap: () {
          print("Bạn đã nhấn vào nghệ sĩ: ${artist.name}");
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.blue.withOpacity(0.3), // Hiệu ứng nước lan tỏa khi nhấn
        child: Ink(
          padding: EdgeInsets.all(8), // Tạo khoảng cách đẹp hơn
          decoration: BoxDecoration(
            // color: Colors.grey[300], // Màu nền ban đầu
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  artist.imageUrl,
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
                  artist.name,
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
