import 'package:flutter/material.dart';

import '../custom/main_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Khi bấm back từ Settings -> luôn quay về Home
        Navigator.of(context).pushReplacementNamed('/');
        return false;
      },
      child: MainLayout(
        title: "Cài đặt",
        body: Center(child: Text("Đây là SettingScreen")),
      ),
    );
  }
}

