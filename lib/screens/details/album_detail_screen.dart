import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/song/song_event.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/models/album.dart';
import 'package:leafmusic_2/models/artist.dart';
import 'package:leafmusic_2/repositories/artist_repository.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/widgets/song_list.dart';

import 'artist_detail_screen.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SongBloc(songRepository: SongRepository()),

      child: MainLayout(
        title: "Album ${album.name}",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          physics: const AlwaysScrollableScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              //Thông tin album
              Center(
                child: Column(
                  children: [

                    ///Hình ảnh
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
                    const SizedBox(height: 10),

                    ///Tên album
                    Text(
                      album.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    /// Gọi API lấy tên ca sĩ từ id
                    FutureBuilder<Artist>(
                      future: ArtistRepository().fetchArtistsInfor(album.idArtist),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text("Không thể tải thông tin ca sĩ");
                        } else {

                          final artist = snapshot.data!;
                          return Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ca sĩ: ",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArtistDetailScreen(artist: artist),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade100, // Màu nền
                                  foregroundColor: Colors.white, // Màu chữ
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text(
                                  artist.name,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.deepPurple.shade800,
                                  ),
                                ),
                              ),

                            ],
                          );


                        }
                      },
                    ),
                    const SizedBox(height: 5),

                    ///Ngày phát hành
                    Text(
                      "Ngày phát hành: "+
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(album.releaseDate.toString())),
                      style: Theme.of(context).textTheme.titleMedium,
                    )

                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Danh sách bài hát",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              SongList(event: LoadSongsByAlbum(album.idAlbum)),


            ],

          ),

        ),
      ),

    );
  }
}
