import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_event.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/models/artist.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/widgets/album_list.dart';
import 'package:leafmusic_2/widgets/song_list.dart';

import '../../bloc/album/album_bloc.dart';
import '../../repositories/album_repository.dart';

class ArtistDetailScreen extends StatelessWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SongBloc(songRepository: SongRepository())),
        BlocProvider(create: (_) => AlbumBloc(albumRepository: AlbumRepository())),
      ],
      child: MainLayout(
        title: "Ca sĩ ${artist.name}",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Avatar + Tên
              Center(
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
                    Text(
                      artist.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Danh sách album
              Text(
                "Danh sách album",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              AlbumList(event: LoadAlbumByArtist(artist.idArtist)),
              const SizedBox(height: 8),

              // Các bài hát
              Text(
                "Các bài hát của ${artist.name}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              SongList(event: LoadTop5SongsByArtist(artist.idArtist)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

  }
}
