class Note {
  final String id;
  final String title;
  final String description;
  final DateTime createdDate;
  final List<String>? tags;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.tags,
  });
}