import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/account/login_bloc.dart';
import 'package:leafmusic_2/repositories/auth_repository.dart';
import 'package:leafmusic_2/screens/main_screen/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => LoginBloc(AuthRepository()),
      child: Scaffold(

        appBar: AppBar(
          title: const Text("Đăng nhập"),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(24.0),

          child: BlocConsumer<LoginBloc, LoginState>(

            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },

            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Tên đăng nhập (Email)
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút Đăng nhập
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) {
                        if (state is LoginLoading) {
                          return ElevatedButton(
                            onPressed: null,
                            child: const CircularProgressIndicator(),
                          );
                        } else {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  email: usernameController.text,
                                  password: passwordController.text,
                                ),
                              );
                            },
                            child: const Text("Đăng nhập"),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nút chuyển qua trang đăng ký
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5FFF),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Chưa có tài khoản? Đăng ký"),
                    ),
                  ),


                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
