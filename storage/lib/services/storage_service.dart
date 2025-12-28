import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class StorageService {
  static final pb = PocketBase('http://127.0.0.1:8090/');

  static Future<List<RecordModel>> getGallery() async {
    return await pb.collection('gallery').getFullList(sort: '-created');
  }

  static Future<void> uploadImage(List<int> bytes, String filename) async {
    await pb
        .collection('gallery')
        .create(
          files: [
            http.MultipartFile.fromBytes('photo', bytes, filename: filename),
          ],
        );
  }

  static Future<void> deleteImage(String id) async {
    await pb.collection('gallery').delete(id);
  }

  static String getImageUrl(RecordModel record) {
    // Ambil string nama file dari field 'photo'
    final fileName = record.getStringValue('photo');
    return pb.files.getUrl(record, fileName).toString();
  }
}
