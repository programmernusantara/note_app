import 'package:flutter/material.dart';
import 'package:online/screens/home_page.dart';
import 'package:online/services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Perbaikan: Tambahkan tanda kurung ()
  }

  void _loadTheme() async {
    final isDark =
        await ThemeService.loadTheme(); // Perbaikan: Typo isDrak -> isDark
    setState(() {
      // Perbaikan: Gunakan ThemeMode, bukan ThemeData
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleTheme() async {
    final isDark = _themeMode == ThemeMode.light;
    await ThemeService.saveTheme(isDark);

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      // Perbaikan: Kirimkan fungsi toggleTheme ke HomePages
      home: HomePages(onThemeToggle: toggleTheme),
    );
  }
}
