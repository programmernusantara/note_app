import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:realtime/services/pb_service.dart';

class SimpleChatPage extends StatefulWidget {
  const SimpleChatPage({super.key});

  @override
  State<SimpleChatPage> createState() => _SimpleChatPageState();
}

class _SimpleChatPageState extends State<SimpleChatPage> {
  // Panggil service yang berisi logika PocketBase
  final PocketBaseService _pbService = PocketBaseService();
  final TextEditingController _controller = TextEditingController();
  List<RecordModel> messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupRealtime();
  }

  // Memuat data pertama kali saat aplikasi dibuka
  Future<void> _loadInitialData() async {
    final initialMessages = await _pbService.fetchMessages();
    setState(() {
      messages = initialMessages;
    });
  }

  // Menyiapkan listener untuk pesan baru (Realtime)
  void _setupRealtime() {
    _pbService.subscribeToMessages((newRecord) {
      setState(() {
        messages.insert(
          0,
          newRecord,
        ); // Tambahkan pesan baru ke baris paling atas
      });
    });
  }

  // Fungsi saat tombol kirim ditekan
  Future<void> _handleSend() async {
    final text = _controller.text;
    _controller.clear(); // Bersihkan input segera agar user merasa responsif
    await _pbService.sendMessage(text);
  }

  @override
  void dispose() {
    _pbService.unsubscribe(); // Pastikan koneksi realtime ditutup
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Chat Sederhana')),
      body: Column(
        children: [
          // Area Daftar Pesan
          Expanded(
            child: ListView.builder(
              reverse: true, // List mulai dari bawah ke atas
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg.getStringValue('content')),
                  subtitle: Text(msg.getStringValue('created')),
                );
              },
            ),
          ),

          // Area Input Pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _handleSend,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
