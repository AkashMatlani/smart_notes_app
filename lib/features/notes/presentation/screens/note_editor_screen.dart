import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/note_model.dart';
import '../providers/notes_provider.dart';
import '../providers/ai_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? note;
  const NoteEditorScreen({this.note, super.key});

  @override
  ConsumerState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final uuid = const Uuid();

  String _summary = '';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descController.text = widget.note!.description;
      _summary = widget.note!.summary ?? '';
    }
  }

  Future<void> _generateSummary() async {
    final text = descController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final summary = await ref.read(aiSummaryProvider(text).future);
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate summary: $e")));
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? createNote : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: title),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: description),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateSummary,
              child: _isGenerating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Generate Summary"),
            ),
            if (_summary.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("Summary:", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(_summary),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final note = NoteModel(
                  id: widget.note?.id ?? uuid.v4(),
                  title: titleController.text,
                  description: descController.text,
                  createdDate: DateTime.now(),
                  summary: _summary, // save AI summary in note
                );

                ref.read(notesProvider.notifier).add(note);
                Navigator.pop(context);
              },
              child: const Text(save),
            ),
          ],
        ),
      ),
    );
  }
}