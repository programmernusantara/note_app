import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Gunakan late agar kita bisa menginisialisasi future di initState
  late Future<List<RecordModel>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFiles(); // Ambil data awal
  }

  void _refreshFiles() {
    setState(() {
      _filesFuture = StorageService.getAllFiles();
    });
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null) return;

    await StorageService.uploadFile(
      bytes: result.files.first.bytes!,
      fileName: result.files.first.name,
    );
    _refreshFiles(); // Refresh UI
  }

  Future<void> downloadFile(RecordModel file) async {
    await StorageService.downloadFile(file);
  }

  Future<void> deleteFile(String fileId) async {
    await StorageService.deleteFile(fileId);
    _refreshFiles(); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Storage')),
      // Menggunakan FutureBuilder agar UI otomatis terupdate berdasarkan status data
      body: FutureBuilder<List<RecordModel>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada file.'));
          }

          final files = snapshot.data!;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                leading: const Icon(
                  Icons.insert_drive_file,
                  color: Colors.blue,
                ),
                title: Text(file.getStringValue('file')),
                subtitle: Text(file.getStringValue('created')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => downloadFile(file),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteFile(file.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadFile,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
