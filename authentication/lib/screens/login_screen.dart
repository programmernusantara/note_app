import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Masuk dengan Google"),
          onPressed: () async {
            await AuthService.loginWithGoogle();
            
            // Jika berhasil login, pindah ke halaman Home
            if (AuthService.isLoggedIn && context.mounted) {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen())
              );
            }
          },
        ),
      ),
    );
  }
}