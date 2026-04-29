class Note {
  final int id;
  final String title;
  final String content;
  final bool status;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.status = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      status: map['status'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
