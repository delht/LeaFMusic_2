import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_bloc.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_event.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_state.dart';
import 'package:leafmusic_2/repositories/customlist_repository.dart';
import 'package:leafmusic_2/screens/main_screen/custom_list_songs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom/main_layout.dart';

class CustomListScreen extends StatefulWidget {
  const CustomListScreen({super.key});

  @override
  State<CustomListScreen> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  String? userId;
  late CustomlistBloc customlistBloc;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    customlistBloc = CustomlistBloc(customListRepository: CustomListRepository());
  }

  /// Hàm lấy id người dùng và load ds dscustom
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (id != null) {
      setState(() {
        userId = id;
      });
      customlistBloc.add(LoadCustomlists(id));
    }
  }

  Future<void> _onRefresh() async {
    await _loadUserId();
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

          title: "Danh sách phát",
          body: BlocBuilder<CustomlistBloc, CustomlistState>(

            builder: (context, state) {

              if (userId == null || state is CustomListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CustomListError) {
                return Center(child: Text("Lỗi: ${state.message}"));
              }

              if (state is CustomListLoaded) {
                final customLists = state.customlist;

                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nút thêm danh sách mới
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: _showAddCustomListDialog,
                          icon: const Icon(Icons.add),
                          label: const Text("Thêm danh sách mới"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //   child: Text(
                      //     "[ Nhấn để xem danh sách yêu thích ]",
                      //     style: TextStyle(fontSize: 16, color: Colors.grey),
                      //   ),
                      // ),

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

                                  ///Hành động khi chọn item
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      _showEditDialog(customList.idList, customList.name);
                                    } else if (value == 'delete') {
                                      customlistBloc.add(DeleteCustomList(
                                        idList: customList.idList,
                                        idUser: userId!,
                                      ));
                                    } else if (value == 'public') {
                                      try {
                                        await CustomListRepository().togglePublicStatus(customList.idList);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật trạng thái công khai thành công')),
                                        );
                                        _onRefresh(); // Refresh lại danh sách
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Lỗi: ${e.toString()}')),
                                        );
                                      }
                                    }
                                  },


                                  /// Danh sách item
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 'edit', child: Text('Sửa'),),
                                    const PopupMenuItem(value: 'delete', child: Text('Xoá'),),
                                    const PopupMenuItem(value: 'public', child: Text('Công khai')),

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

  ///Dialog Thêm
  void _showAddCustomListDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo danh sách mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nhập tên danh sách'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (userId != null && controller.text.trim().isNotEmpty) {
                customlistBloc.add(AddCustomList(
                  name: controller.text.trim(),
                  idUser: userId!,
                ));
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  ///Dialog sửa
  void _showEditDialog(int idList, String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sửa danh sách"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nhập tên mới"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                customlistBloc.add(UpdateCustomList(
                  idList: idList,
                  newName: newName,
                  idUser: userId!,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }




}

