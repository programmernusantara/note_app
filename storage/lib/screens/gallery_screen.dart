import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool loading = false;
  List items = [];

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    setState(() => loading = true);
    items = await StorageService.getGallery();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () async {
              final xFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (xFile != null) {
                await StorageService.uploadImage(
                  await xFile.readAsBytes(),
                  xFile.name,
                );
                refreshData();
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Mengatur tinggi kotak agar pas
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final fileName = item.getStringValue('photo');

                return Card(
                  clipBehavior:
                      Clip.antiAlias, // Agar foto mengikuti lekukan Card
                  child: Column(
                    children: [
                      // --- Bagian Atas: Nama & Hapus ---
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await StorageService.deleteImage(item.id);
                                refreshData();
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // --- Bagian Bawah: Foto ---
                      Expanded(
                        child: Image.network(
                          StorageService.getImageUrl(item),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
