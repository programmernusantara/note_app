import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:offline/service/hive_service.dart';

class NotesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const NotesScreen({super.key, required this.onThemeToggle});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  void _addNote() {
    if (_addController.text.trim().isEmpty) return;
    HiveService.addNote(_addController.text);
    _addController.clear();
  }

  void _editNote(int index, String oldText) {
    _editController.text = oldText;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: TextField(controller: _editController),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              _editController.clear();
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () {
              if (_editController.text.trim().isEmpty) return;
              HiveService.editNote(index, _editController.text);
              _editController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = HiveService.box;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assalamualaikum'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (_, box, __) {
                if (box.isEmpty) {
                  return const Center(child: Text('Belum ada catatan'));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (_, i) {
                    final note = box.getAt(i);

                    return ListTile(
                      leading: Checkbox(
                        value: note['isDone'],
                        onChanged: (_) =>
                            HiveService.toggleNote(i),
                      ),
                      title: Text(
                        note['text'],
                        style: TextStyle(
                          decoration: note['isDone']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _editNote(i, note['text']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                HiveService.deleteNote(i),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration:
                        const InputDecoration(hintText: 'Tambah catatan...'),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 30),
                  onPressed: _addNote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
