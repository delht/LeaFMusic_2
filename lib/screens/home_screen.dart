import 'package:flutter/material.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
import 'package:leafmusic_2/models/album.dart';
import 'package:leafmusic_2/widgets/song_list.dart';
import 'package:leafmusic_2/widgets/artist_list.dart';
import 'package:leafmusic_2/widgets/album_list.dart';
import 'package:leafmusic_2/models/song.dart';
import 'package:leafmusic_2/models/artist.dart';
import 'package:leafmusic_2/services/api_service.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> songs = [];
  List<Artist> artists = [];
  List<Album> albums = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      List<Song> fetchedSongs = await ApiService.fetchSongs();
      List<Artist> fetchedArtists = await ApiService.fetchArtists();
      List<Album> fetchedAlbums = await ApiService.featchAlbum();

      setState(() {
        songs = fetchedSongs;
        artists = fetchedArtists;
        albums = fetchedAlbums;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitConfirmation(context);
        return shouldExit;
      },
      child: MainLayout(
        title: "Trang chủ",
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SectionTitle(title: "Bài hát đề xuất"),

                    if (hasError)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    else
                      SongList(songs: songs),

                    SizedBox(height: 10),
                    SectionTitle(title: "Top ca sĩ"),
                    if (artists.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    else
                      ArtistList(artists: artists),

                    SizedBox(height: 10),
                    SectionTitle(title: "Album nổi bật"),
                    if (albums.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    else
                      AlbumList(albums: albums),

                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận thoát"),
        content: Text("Bạn có chắc chắn muốn thoát ứng dụng không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Không"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Có"),
          ),
        ],
      ),
    ) ?? false;
  }
}
