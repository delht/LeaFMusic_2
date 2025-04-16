import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/auth_repository.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khai báo controller để lấy dữ liệu từ TextField
    final TextEditingController passwordOldController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ===================================================================

            /// Email
            TextField(
              controller: passwordOldController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu cũ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            /// Mật khẩu
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            /// Nhập lại mật khẩu
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nhập lại mật khẩu mới',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ===================================================================

            // Nút Đổi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Màu tím nhạt
                  foregroundColor: Colors.white,
                ),

                onPressed: () async {
                  final passOld = passwordOldController.text;
                  final password = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (passOld.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thông tin mật khẩu không giống nhau'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getString('userId');

                    if (userId == null) {
                      throw Exception('Không tìm thấy người dùng');
                    }

                    await AuthRepository().changePassword(
                      userId: userId,
                      oldPassword: passOld,
                      newPassword: password,
                    );

                    passwordOldController.clear();
                    passwordController.clear();
                    confirmPasswordController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đổi mật khẩu thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },

                child: const Text("Đổi mật khẩu"),

              ),
            ),
            const SizedBox(height: 10),

            // Nút quay lại đăng nhập
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // Trở lại màn hình trước
                },
                child: const Text("Quay lại"),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
