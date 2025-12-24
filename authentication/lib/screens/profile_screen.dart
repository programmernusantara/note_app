import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    // Ambil avatar user
    String avatarUrl = '';
    if (user != null && user.getStringValue('avatar') != '') {
      avatarUrl =
          '${AuthService.pb.baseURL}/api/files/${user.collectionId}/${user.id}/${user.getStringValue('avatar')}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,

        // ⬇️ TOMBOL SILANG (GANTI PANAH)
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya (Home)
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),

            const SizedBox(height: 20),

            // Nama
            Text(
              user?.getStringValue('name') ?? 'User',
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              user?.getStringValue('email') ?? '-',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Logout
            ElevatedButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
