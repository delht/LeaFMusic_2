import 'package:flutter/material.dart';
import 'package:leafmusic_2/custom/main_layout.dart';
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

      // Gọi API để lấy dữ liệu
      List<Song> fetchedSongs = await ApiService.fetchSongs();
      List<Artist> fetchedArtists = await ApiService.fetchArtists();

      setState(() {
        songs = fetchedSongs;
        artists = fetchedArtists;
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
                padding: const EdgeInsets.all(8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SectionTitle(title: "Bài hát đề xuất"),

                    if (hasError)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    else
                      SongList(songs: songs),

                    const SizedBox(height: 10),
                    const SectionTitle(title: "Top ca sĩ"),
                    if (artists.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Không có dữ liệu nghệ sĩ"),
                        ),
                      )
                    else
                      ArtistList(artists: artists),

                    const SizedBox(height: 10),
                    const SectionTitle(title: "Album nổi bật"),
                    const AlbumList(),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
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
        title: const Text("Xác nhận thoát"),
        content: const Text("Bạn có chắc chắn muốn thoát ứng dụng không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Có"),
          ),
        ],
      ),
    ) ?? false;
  }
}
