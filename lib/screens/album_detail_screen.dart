// import 'package:flutter/material.dart';
// import 'package:leafmusic_2/custom/main_layout.dart';
// import 'package:leafmusic_2/models/album.dart';
// import 'package:leafmusic_2/models/song.dart';
// import 'package:leafmusic_2/services/api_service.dart';
//
// import '../widgets/song_list.dart';
//
// class AlbumDetailScreen extends StatefulWidget {
//   final Album album;
//
//   const AlbumDetailScreen({super.key, required this.album});
//
//   @override
//   _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
// }
//
// class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
//   late Future<List<Song>> futureSongs;
//
//   @override
//   void initState() {
//     super.initState();
//     futureSongs = ApiService.fetchSongsFromAlbumID(widget.album.idAlbum);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       title: widget.album.name,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Align(
//                 alignment: Alignment.center,
//                 child: Image.network(
//                   widget.album.imageUrl,
//                   width: 250,
//                   height: 300,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.asset(
//                       'assets/images/default_song_image.png',
//                       width: 150,
//                       height: 200,
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               Text(
//                 "Thông tin album",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Tên: ${widget.album.name}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 "Ngày phát hành: ${widget.album.formattedReleaseDate}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 "ID ca sĩ: ${widget.album.idArtist}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//
//               Text(
//                 "Danh sách bài hát",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               ),
//               SizedBox(height: 10),
//
//               FutureBuilder<List<Song>>(
//                 future: futureSongs,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text("Lỗi tải danh sách bài hát"));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text("Không có bài hát nào"));
//                   }
//
//                   return SongList(songs: snapshot.data!);
//                 },
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
