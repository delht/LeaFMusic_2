import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/screens/home_screen.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_bloc.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/repositories/album_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SongBloc(songRepository: SongRepository())),
        BlocProvider(create: (context) => AlbumBloc(albumRepository: AlbumRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
