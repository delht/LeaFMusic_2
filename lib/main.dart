import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leafmusic_2/core/auth_manager.dart';
import 'package:leafmusic_2/bloc/search/search_bloc.dart';
import 'package:leafmusic_2/repositories/search_repository.dart';
import 'package:leafmusic_2/screens/account/login_screen.dart';
import 'package:leafmusic_2/screens/main_screen/custom_list_screen.dart';
import 'package:leafmusic_2/screens/main_screen/home_screen.dart';
import 'bloc/theme/theme_cubit.dart';
import 'bloc/song/song_bloc.dart';
import 'bloc/album/album_bloc.dart';
import 'bloc/artist/artist_bloc.dart';
import 'repositories/song_repository.dart';
import 'repositories/album_repository.dart';
import 'repositories/artist_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  ///Lưu, chuyển đổi sáng tối
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();

  final isLoggedIn = await AuthManager.isLoggedIn(); ///Check đăng nhập

  runApp(
    BlocProvider.value(
      value: themeCubit,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ///Tạo các BLOC, sử dụng cho toàn bộ app
        ///Các Repo để lấy data
        BlocProvider(create: (_) => SongBloc(songRepository: SongRepository())),
        BlocProvider(create: (_) => AlbumBloc(albumRepository: AlbumRepository())),
        BlocProvider(create: (_) => ArtistBloc(artistRepository: ArtistRepository())),
        BlocProvider(create: (_) => SearchBloc(searchRepository: SearchRepository())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,

            home: isLoggedIn ? const HomeScreen() : const LoginScreen(),

            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              'customlist': (context) => const CustomListScreen(),
            },
          );
        },
      ),
    );
  }
}
