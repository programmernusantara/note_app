import 'package:authentication/screens/profile_screen.dart';
import 'package:authentication/services/crud_service.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controller untuk input catatan baru
  final TextEditingController _controller = TextEditingController();

  late Future<List<RecordModel>> _notes;

  //Ambil ulang data catatan setiap kali ada perubahan
  void _refreshNotes() {
    _notes = CrudService.getMyNote();
  }

  // Tambah catatan baru
  Future<void> _addNote() async {
    if (_controller.text.isEmpty) return;

    await CrudService.addNote(_controller.text);
    _controller.clear();
    setState(_refreshNotes);
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<RecordModel>>(
              future: _notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Belum ada catatan'));
                } else {
                  final notes = snapshot.data!;
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return ListTile(
                        title: Text(
                          note.getStringValue('title'),
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tambah catatan...',
                    ),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                IconButton(onPressed: _addNote, icon: Icon(Icons.add_circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
