import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // 1. Wajib ada jika main() menggunakan async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Hubungkan ke PocketBase sebelum aplikasi muncul
  await AuthService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 3. Cek status login: Jika TRUE ke Home, jika FALSE ke Login
      home: AuthService.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
