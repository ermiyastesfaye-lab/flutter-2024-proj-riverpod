import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyColor {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  MyColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  factory MyColor.lightMode() {
    return MyColor(
      primary: Colors.grey,
      secondary: const Color.fromARGB(255, 33, 119, 50),
      tertiary: const Color.fromARGB(255, 103, 103, 103),
    );
  }

  factory MyColor.darkMode() {
    return MyColor(
      primary: const Color.fromARGB(255, 22, 22, 22),
      secondary: const Color.fromARGB(255, 0, 64, 0),
      tertiary: Colors.white,
    );
  }

  get background => null;
}

// StateNotifier for the theme
class ThemeNotifier extends StateNotifier<MyColor> {
  ThemeNotifier(super.state);

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.primary == Colors.grey) {
      state = MyColor.darkMode();
      await prefs.setBool('isDark', true);
    } else {
      state = MyColor.lightMode();
      await prefs.setBool('isDark', false);
    }
  }
}

// Provider for the ThemeNotifier
final myColorProvider = StateNotifierProvider<ThemeNotifier, MyColor>((ref) {
  return ThemeNotifier(MyColor.lightMode());
});
