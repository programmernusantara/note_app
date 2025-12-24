import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  // Setup URL PocketBase
 static final pb = PocketBase('http://127.0.0.1:8090'); // Gunakan localhost untuk Web

  // Cek login (true/false)
  static bool get isLoggedIn => pb.authStore.isValid;

  // Ambil data user (Gunakan .record, bukan .model)
  static RecordModel? get currentUser => pb.authStore.record;

  // Login Google
  static Future<void> loginWithGoogle() async {
    await pb.collection('users').authWithOAuth2('google', (url) async {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    });
  }

  // Logout
  static void logout() => pb.authStore.clear();
}