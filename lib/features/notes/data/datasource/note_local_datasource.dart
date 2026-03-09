import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NoteLocalDatasource {
  final box = Hive.box<NoteModel>('notes');

  List<NoteModel> getNotes() {
    return box.values.toList();
  }

  Future<void> add(NoteModel note) async {
    await box.put(note.id, note);
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }
}