import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_state.dart';
import 'package:leafmusic_2/bloc/album/album_event.dart';
import 'package:leafmusic_2/models/album.dart';
import 'package:leafmusic_2/screens/details/album_detail_screen.dart';

class AlbumList extends StatelessWidget {
  // const AlbumList({super.key});

  final AlbumEvent event;
  const AlbumList({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        if (state is AlbumInitial) {
          // context.read<AlbumBloc>().add(LoadAlbums());
          context.read<AlbumBloc>().add(event);
          return const Center(child: CircularProgressIndicator());
        } else if (state is AlbumLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AlbumError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Lỗi: ${state.message}", // Hiển thị lỗi chi tiết
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is AlbumLoaded) {
          List<Album> albums = state.albums;
          return SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _buildAlbumItem(context, albums[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAlbumItem(BuildContext context, Album album) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print("Bạn đã nhấn vào album: ${album.name}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumDetailScreen(album: album),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.blue.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
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
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: Text(
                  album.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
