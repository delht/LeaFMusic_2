import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  // Khởi tạo với trạng thái từ SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;  // Mặc định là light
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  // Thay đổi chế độ sáng/tối và lưu trạng thái vào SharedPreferences
  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);  // Lưu trạng thái
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
