import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_bloc.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_event.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_state.dart';
import 'package:leafmusic_2/repositories/customlist_repository.dart';
import 'package:leafmusic_2/screens/main_screen/custom_list_songs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom/main_layout.dart';

class Publicalbum extends StatefulWidget {
  const Publicalbum({super.key});

  @override
  State<Publicalbum> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<Publicalbum> {
  // String? userId;
  late CustomlistBloc customlistBloc;

  @override
  void initState() {
    super.initState();
    customlistBloc = CustomlistBloc(customListRepository: CustomListRepository());
    customlistBloc.add(LoadCustomlistsPublic());
  }

  Future<void> _onRefresh() async {
    // await _loadUserId();
    customlistBloc.add(LoadCustomlistsPublic());
  }

  ///======================================================================================

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },

      child: BlocProvider.value(

        value: customlistBloc,

        child: MainLayout(

          title: "Danh sách phát của người khác",
          body: BlocBuilder<CustomlistBloc, CustomlistState>(

            builder: (context, state) {

              if (state is CustomListError) {
                return Center(child: Text("Lỗi: ${state.message}"));
              }

              if (state is CustomListLoaded) {
                final customLists = state.customlist; ///data api

                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            itemCount: customLists.length,
                            itemBuilder: (context, index) {
                              final customList = customLists[index];

                              return ListTile(

                                title: Text(customList.name),
                                leading: const Icon(Icons.music_note),
                                trailing: PopupMenuButton<String>( ///Menu nhỏ khi bấm vào 3 chấm
                                  // icon: Icon(Icons.more_vert),

                                  // ///Hành động khi chọn item
                                  onSelected: (value) async {
                                    if (value == 'add') {
                                      final prefs = await SharedPreferences.getInstance();
                                      final idUser = prefs.getString('userId');

                                      if (idUser != null) {
                                        try {
                                          await CustomListRepository().clone(customList.idList, idUser);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Thêm thành công!')),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Lỗi: $e')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Không tìm thấy người dùng!')),
                                        );
                                      }
                                    }
                                  },



                                  /// Danh sách item
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 'add', child: Text('Thêm'),),
                                  ],
                                ),

                                onTap: () {
                                  /// Mở danh sách bài hát
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CustomListSongsScreen(
                                        idList: customList.idList,
                                        name: customList.name,
                                      ),
                                    ),
                                  );
                                },


                              );
                            },


                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("Danh sách yêu thích sẽ được hiển thị ở đây"));
            },
          ),
        ),
      ),
    );
  }

  ///===============================================================================================






}

