import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/screens/home_screen.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SongRepository(),
      child: BlocProvider(
        create: (context) => SongBloc(context.read<SongRepository>()),
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
  }
}
