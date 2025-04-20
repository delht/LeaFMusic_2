import 'package:flutter/material.dart';
import 'package:leafmusic_2/screens/main_screen/account_screen.dart';
import 'package:leafmusic_2/screens/main_screen/favorite_list_screen.dart';
import '../core/auth_manager.dart';
import '../screens/main_screen/home_screen.dart';
import '../screens/main_screen/settings_screen.dart';
import '../screens/main_screen/search_screen.dart';
import '../screens/account/login_screen.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  Future<String> _getUsername() async {
    final prefs = await AuthManager.isLoggedIn();
    if (!prefs) return "Khách";
    final username = (await AuthManager.getUsername()) ?? "Khách";
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          FutureBuilder<String>(
            future: _getUsername(),
            builder: (context, snapshot) {

              final username = snapshot.data ?? "Đang tải...";

              return DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.green,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    // const CircleAvatar(
                    //   radius: 30,
                    //   backgroundImage: AssetImage("assets/images/leaf.avif"),
                    //   backgroundColor: Colors.white,
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],


                ),
              );
            },
          ),

          // =================== Danh sách menu ===================

          ///TRANG CHỦ
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Trang chủ"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),

          ///TÌM KIẾM
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Tìm kiếm"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),

          ///DANH SÁCH YÊU THÍCH
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red, size: 30),
            title: const Text("Danh sách yêu thích"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FavoriteListScreen()),
              );
            },
          ),


          const Divider(thickness: 1, height: 20),

          ///TÀI KHOẢN
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Tài khoản"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AccountScreen()));
              }),

          ///CÀI ĐẶT
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Cài đặt"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SettingsScreen()));
            },
          ),

          const Divider(thickness: 1, height: 20),

          ///ĐĂNG XUẤT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Đăng xuất"),
            onTap: () async {
              await AuthManager.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
