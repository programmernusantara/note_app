import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

void main() {
  // menjalankan aplikasi Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // halaman utama
    );
  }
}
