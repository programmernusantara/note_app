import 'package:authentication/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda"),
        centerTitle: true,
        actions: [
          // Tombol di pojok kanan untuk buka halaman Profil.
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Pindah ke ProfileScreen (tumpuk layar di atas Home).
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Assalamualaikum",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}