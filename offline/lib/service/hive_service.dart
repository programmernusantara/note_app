import 'package:hive/hive.dart';

class HiveService {
  static final box = Hive.box('storageNotes');

  static void addNote(String text) {
    box.add({'text': text, 'isDone': false});
  }

  static void toggleNote(int index) {
    final note = box.getAt(index);
    box.putAt(index, {
      'text': note['text'],
      'isDone': !note['isDone'],
    });
  }

  static void editNote(int index, String text) {
    final note = box.getAt(index);
    box.putAt(index, {
      'text': text,
      'isDone': note['isDone'],
    });
  }

  static void deleteNote(int index) {
    box.deleteAt(index);
  }
}
