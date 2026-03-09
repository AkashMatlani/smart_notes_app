import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';

class NoteTile extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onDelete;
  const NoteTile({
    super.key,
    required this.note,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}