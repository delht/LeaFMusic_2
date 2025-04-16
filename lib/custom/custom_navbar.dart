import 'package:flutter/material.dart';
import 'package:leafmusic_2/screens/account_screen.dart';

import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/search_screen.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit:  BoxFit.cover
                ),
                color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/leaf.avif"),
                  backgroundColor: Colors.white,
                ),
                // Icon(Icons.account_circle, size: 60, color: Colors.white,),
                SizedBox(height: 10),
                Text("Username", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
              ],
            ),
          ),

          // =================== Danh sách menu ===================

          ListTile(
            leading: Icon(Icons.home),
            title: Text("Trang chủ"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen())
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.search),
            title: Text("Tìm kiếm"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  SearchScreen())
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red, size: 30),
            title: Text("Danh sách yêu thích"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  SearchScreen())
              );
            },
          ),


          const Divider(thickness: 1, height: 20),

          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Tài khoản"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AccountScreen())
              );
            }
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Cài đặt"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SettingsScreen())
              );
            },
          ),

          const Divider(thickness: 1, height: 20),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Đăng xuất"),
            onTap: () => null,
          ),

          // =============================================================================================================================

        ],
      ),
    );
  }
}
