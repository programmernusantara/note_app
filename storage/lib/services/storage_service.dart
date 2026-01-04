import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StorageService {
  // koneksi ke PocketBase
  static final PocketBase pb = PocketBase('http://127.0.0.1:8090');

  // nama collection
  static const String collection = 'files';

  // ambil semua file
  static Future<List<RecordModel>> getAllFiles() async {
    return pb.collection(collection).getFullList(sort: '-created');
  }

  // upload file
  static Future<void> uploadFile({
    required List<int> bytes,
    required String fileName,
  }) async {
    await pb
        .collection(collection)
        .create(
          files: [
            http.MultipartFile.fromBytes('file', bytes, filename: fileName),
          ],
        );
  }

  // download file
  static Future<void> downloadFile(RecordModel record) async {
    final fileName = record.getStringValue('file');

    // ambil url file dari PocketBase
    final Uri url = pb.files.getUrl(record, fileName);

    // paksa browser agar file di-download
    final Uri downloadUrl = url.replace(
      queryParameters: {...url.queryParameters, 'download': '1'},
    );

    if (await canLaunchUrl(downloadUrl)) {
      await launchUrl(downloadUrl, mode: LaunchMode.externalApplication);
    }
  }

  // hapus file
  static Future<void> deleteFile(String id) async {
    await pb.collection(collection).delete(id);
  }
}
