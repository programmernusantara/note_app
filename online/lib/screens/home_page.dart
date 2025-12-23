import 'package:flutter/material.dart';
import 'package:online/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  // Controller untuk input catatan baru
  final TextEditingController _noteController = TextEditingController();

  // Menyimpan data catatan dari PocketBase
  late Future<List<RecordModel>> _notes;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  // Ambil ulang data catatan
  void _refreshNotes() {
    _notes = PocketbaseService.getAllNote();
  }

  // Tambah catatan baru
  Future<void> _addNote() async {
    if (_noteController.text.isEmpty) return;

    await PocketbaseService.addNote(_noteController.text);
    _noteController.clear();

    setState(_refreshNotes);
  }

  // Hapus catatan
  Future<void> _deleteNote(String id) async {
    await PocketbaseService.deleteNote(id);
    setState(_refreshNotes);
  }

  // Ubah status selesai / belum
  Future<void> _toggleDone(String id, bool isDone) async {
    await PocketbaseService.toggleDone(id, isDone);
    setState(_refreshNotes);
  }

  // Dialog edit catatan
  void _editNote(RecordModel note) {
    final controller = TextEditingController(
      text: note.getStringValue('title'),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await PocketbaseService.updateNote(note.id, controller.text);
              if (!mounted) return;
              setState(_refreshNotes);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // LIST CATATAN
          Expanded(
            child: FutureBuilder<List<RecordModel>>(
              future: _notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada catatan'));
                }

                final notes = snapshot.data!;

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    final note = notes[index];
                    final isDone = note.getBoolValue('is_done');

                    return ListTile(
                      leading: Checkbox(
                        value: isDone,
                        onChanged: (_) => _toggleDone(note.id, isDone),
                      ),
                      title: Text(
                        note.getStringValue('title'),
                        style: TextStyle(
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isDone ? Colors.grey : Colors.black,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') _editNote(note);
                          if (value == 'delete') _deleteNote(note.id);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // INPUT CATATAN
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Tambah catatan...',
                    ),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _addNote),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
