import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.dashboard, color: Colors.white, size: 30), // Đổi icon ở đây
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Mở Navbar khi bấm
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
