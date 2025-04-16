import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/screens/account/change_password_screen.dart';

import '../../bloc/theme/theme_cubit.dart';
import '../../custom/main_layout.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: MainLayout(
        title: "Tài khoản",
        body: Column(
          children: [

            // Thay đổi mật khẩu
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Thay đổi mật khẩu"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
            // const Divider(),

            // Thông tin cá nhân
            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: const Text("Thông tin cá nhân"),
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   onTap: () {
            //     // LOGIC
            //   },
            // ),
            // const Divider(),

          ],
        ),
      ),
    );
  }
}
