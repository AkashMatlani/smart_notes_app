import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdDate;

  @HiveField(4)
  List<String>? tags;

  @HiveField(5)
  String? summary;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.tags,
    this.summary,
  });
}