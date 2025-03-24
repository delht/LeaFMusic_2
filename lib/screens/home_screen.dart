import 'package:flutter/material.dart';
import 'package:leafmusic_2/custom/main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitConfirmation(context);
        return shouldExit;
      },
      child: MainLayout(
        title: "Trang chủ",
        body: const Center(child: Text("Đây là HomeScreen")),
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận thoát ứng dụng
  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận thoát"),
        content: const Text("Bạn có chắc chắn muốn thoát ứng dụng không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Không thoát
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Thoát
            child: const Text("Có"),
          ),
        ],
      ),
    ) ??
        false; // Nếu hộp thoại bị đóng, mặc định không thoát
  }
}
