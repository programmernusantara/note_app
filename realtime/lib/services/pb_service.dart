import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  // Inisialisasi instance PocketBase
  // Ganti URL jika server Anda berada di alamat yang berbeda
  final PocketBase pb = PocketBase('http://127.0.0.1:8090');

  // Mengambil daftar pesan awal dari koleksi 'messages'
  Future<List<RecordModel>> fetchMessages() async {
    final result = await pb.collection('messages').getList(
      sort: '-created', // Urutkan berdasarkan yang terbaru
    );
    return result.items;
  }

  // Melakukan langganan (subscribe) ke perubahan data realtime
  void subscribeToMessages(Function(RecordModel) onNewMessage) {
    pb.collection('messages').subscribe('*', (e) {
      if (e.action == 'create' && e.record != null) {
        onNewMessage(e.record!);
      }
    });
  }

  // Mengirim pesan baru ke koleksi 'messages'
  Future<void> sendMessage(String content) async {
    if (content.isEmpty) return;
    await pb.collection('messages').create(body: {
      'content': content,
    });
  }

  // Berhenti berlangganan (unsubscribe) untuk menghemat resource
  void unsubscribe() {
    pb.collection('messages').unsubscribe('*');
  }
}