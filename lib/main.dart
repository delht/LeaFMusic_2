import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leafmusic_2/repositories/artist_repository.dart';
import 'package:leafmusic_2/screens/home_screen.dart';
import 'package:leafmusic_2/bloc/song/song_bloc.dart';
import 'package:leafmusic_2/bloc/album/album_bloc.dart';
import 'package:leafmusic_2/repositories/song_repository.dart';
import 'package:leafmusic_2/repositories/album_repository.dart';

import 'bloc/artist/artist_bloc.dart';
import 'bloc/theme/theme_cubit.dart';

// void main() {
//   runApp(const MyApp());
// }

// Future<void> main() async{
//   await dotenv.load(fileName: ".env");
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Đảm bảo Flutter đã khởi tạo


  await dotenv.load(fileName: ".env");        // Load file .env
  print("IPv4: ${dotenv.env['IPv4']}");


  // WidgetsFlutterBinding.ensureInitialized();  // Đảm bảo Flutter đã khởi tạo
  await dotenv.load(fileName: ".env");        // Load file .env
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();


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
        BlocProvider(create: (context) => ArtistBloc(artistRepository: ArtistRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
