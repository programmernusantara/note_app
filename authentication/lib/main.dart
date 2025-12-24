import 'package:authentication/screens/home_screen.dart';
import 'package:authentication/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';


void main() {
  // Pastikan binding flutter sudah siap sebelum menjalankan app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketBase Flutter',
      // Cek status login saat aplikasi dibuka
      home: AuthService.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}