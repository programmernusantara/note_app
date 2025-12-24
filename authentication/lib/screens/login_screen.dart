import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Login Google"),
          onPressed: () async {
            // Panggil fungsi login
            await AuthService.loginWithGoogle();
            
            // Jika berhasil, pindah halaman
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