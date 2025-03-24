import 'package:flutter/material.dart';
import 'package:leafmusic_2/custom/custom_navbar.dart';
import 'package:leafmusic_2/custom/custom_appbar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const MainLayout({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      drawer: const Navbar(),
      body: body,
    );
  }
}
