import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/theme/theme_cubit.dart';
import 'screens/home_screen.dart';
import 'bloc/song/song_bloc.dart';
import 'bloc/album/album_bloc.dart';
import 'bloc/artist/artist_bloc.dart';
import 'repositories/song_repository.dart';
import 'repositories/album_repository.dart';
import 'repositories/artist_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme(); // Load từ SharedPreferences trước khi runApp

  runApp(
    BlocProvider.value(
      value: themeCubit,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SongBloc(songRepository: SongRepository())),
        BlocProvider(create: (_) => AlbumBloc(albumRepository: AlbumRepository())),
        BlocProvider(create: (_) => ArtistBloc(artistRepository: ArtistRepository())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode, // Áp dụng chế độ theme hiện tại
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
