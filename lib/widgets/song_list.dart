import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/bloc/song/song_state.dart';
import 'package:leafmusic_2/models/song.dart';

class SongList extends StatelessWidget {
  // const SongList({super.key});

  final SongEvent event;
  const SongList({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongInitial) {

          // context.read<SongBloc>().add(LoadSongs());
          context.read<SongBloc>().add(event);
          return const Center(child: CircularProgressIndicator());

        } else if (state is SongLoading) {

          return const Center(child: CircularProgressIndicator());

        } else if (state is SongError) {
          
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

        } else if (state is SongLoaded) {

          List<Song> songs = state.songs;

          if (songs.isEmpty) {
            return Center(
              child: Text(
                "Trống",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }

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
                      return Image.asset(
                        'assets/images/default_song_image.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                title: Text(song.name),
                subtitle: Text("Nghệ sĩ ${song.idArtist}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              );
            },
          );

        }
        return const SizedBox.shrink();
      },
    );
  }
}
