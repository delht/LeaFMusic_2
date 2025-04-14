import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/artist/artist_bloc.dart';
import 'package:leafmusic_2/bloc/artist/artist_state.dart';
import 'package:leafmusic_2/bloc/artist/artist_event.dart';
import 'package:leafmusic_2/models/artist.dart';
import 'package:leafmusic_2/screens/details/artist_detail_screen.dart';

class ArtistList extends StatelessWidget {
  const ArtistList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistBloc, ArtistState>(
      builder: (context, state) {
        if (state is ArtistInitial) {
          context.read<ArtistBloc>().add(LoadArtists());
          return const Center(child: CircularProgressIndicator());
        } else if (state is ArtistLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ArtistError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Lỗi: ${state.message}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is ArtistLoaded) {
          List<Artist> artists = state.artists;
          return SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: artists.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _buildArtistItem(context, artists[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildArtistItem(BuildContext context, Artist artist) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print("Bạn đã nhấn vào nghệ sĩ: ${artist.name}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailScreen(artist: artist),
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
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: Text(
                  artist.name,
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