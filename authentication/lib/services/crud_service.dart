import 'package:authentication/services/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';

class CrudService {
  static Future<void> addNote(String title) async {
    await AuthService.pb
        .collection('notes')
        .create(body: {"title": title, "user": AuthService.user?.id});
  }

  static Future<List<RecordModel>> getMyNote() async {
    return await AuthService.pb
        .collection('notes')
        .getFullList(
          sort: '-created',
          filter: 'user = "${AuthService.user?.id}"',
        );
  }
}
