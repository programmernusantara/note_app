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
  // data file dari server
  List<RecordModel> files = [];

  // status loading
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFiles(); // ambil data saat halaman dibuka
  }

  // ambil semua file
  Future<void> loadFiles() async {
    setState(() => isLoading = true);
    files = await StorageService.getAllFiles();
    setState(() => isLoading = false);
  }

  // upload file
  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    if (result == null) return;

    setState(() => isLoading = true);

    await StorageService.uploadFile(
      bytes: result.files.first.bytes!,
      fileName: result.files.first.name,
    );

    await loadFiles(); // refresh data
  }

  // download file
  Future<void> downloadFile(RecordModel file) async {
    await StorageService.downloadFile(file);
  }

  // hapus file
  Future<void> deleteFile(String fileId) async {
    setState(() => isLoading = true);
    await StorageService.deleteFile(fileId);
    await loadFiles(); // refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Storage')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : files.isEmpty
          ? const Center(child: Text('Belum ada file'))
          : ListView.builder(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadFile,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
