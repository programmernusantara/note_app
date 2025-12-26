import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static late PocketBase pb;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan data login otomatis agar tidak logout saat aplikasi ditutup
    final store = AsyncAuthStore(
      save: (data) => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
      clear: () => prefs.remove('pb_auth'),
    );

    // Ganti URL ini dengan IP server PocketBase kamu
    pb = PocketBase('http://127.0.0.1:8090', authStore: store);
  }

  // Cek apakah token masih berlaku
  static bool get isLoggedIn => pb.authStore.isValid;

  // Ambil data user yang sedang login
  static RecordModel? get user => pb.authStore.record;

  /// Melakukan autentikasi OAuth2 menggunakan provider Google.
  static Future<void> loginWithGoogle() async {
    // Memulai proses OAuth2 dan menunggu konfirmasi berhasil dari server.
    await pb.collection('users').authWithOAuth2('google', (url) async {
      // Membuka browser eksternal untuk proses login user.
      await launchUrl(url, mode: LaunchMode.externalApplication);
    });
  }

  // Fungsi Logout
  static void logout() {
    pb.authStore.clear(); // Hapus token/sesi
  }
}
