import 'package:pocketbase/pocketbase.dart';

class PocketbaseService {
  static final pb = PocketBase('http://127.0.0.1:8090/');

  static Future<List<RecordModel>> getAllNote() async {
    return await pb
        .collection('notes')
        .getFullList(sort: 'is_done,-created');
  }

  static Future<void> addNote(String title) async {
    await pb.collection('notes').create(
      body: {
        'title': title,
        'is_done': false,
      },
    );
  }

  static Future<void> deleteNote(String id) async {
    await pb.collection('notes').delete(id);
  }

  static Future<void> updateNote(String id, String title) async {
    await pb.collection('notes').update(id, body: {'title': title});
  }

  static Future<void> toggleDone(String id, bool isDone) async {
    await pb.collection('notes').update(
      id,
      body: {'is_done': !isDone},
    );
  }
}
