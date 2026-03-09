import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/note_local_datasource.dart';
import '../../data/models/note_model.dart';

class NotesNotifier extends StateNotifier<List<NoteModel>> {

  NotesNotifier() : super([]);

  final datasource = NoteLocalDatasource();

  int page = 0;
  int limit = 10;


  Future<void> add(NoteModel note) async {
    await datasource.add(note);
    page = 0;
    state = [];
    loadNotes();
  }

  Future<void> delete(String id) async {
    await datasource.delete(id);
    page = 0;
    state = [];
    loadNotes();
  }
  void loadNotes() {
    final all = datasource.getNotes();
    final start = page * limit;
    final end = start + limit;
    if (start >= all.length) return;
    final newNotes =
    all.sublist(start, end > all.length ? all.length : end);
    state = [...state, ...newNotes];
    page++;
  }
}

final notesProvider =
StateNotifierProvider<NotesNotifier, List<NoteModel>>(
      (ref) => NotesNotifier(),
);