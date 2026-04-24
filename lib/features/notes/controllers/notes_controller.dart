import 'package:flutter_ui/features/notes/models/note.dart';

class NotesController {
  final List<Note> _notes = [];
  String _searchQuery = '';

  List<Note> get notes => List.unmodifiable(_notes);

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) return notes;

    return _notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery) ||
          note.content.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase().trim();
  }

  void addNote(String title, String content) {
    _notes.insert(
      0,
      Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
  }

  void updateNote(int id, String title, String content) {
    final index = _notes.indexWhere((n) => n.id == id);

    if (index == -1) return;

    final old = _notes[index];

    _notes[index] = Note(
      id: id,
      title: title,
      content: content,
      createdAt: old.createdAt,
    );
  }

  void deleteNoteById(int id) {
    _notes.removeWhere((n) => n.id == id);
  }

  Note getNoteById(int id) {
    return notes.firstWhere((note) => note.id == id,
        orElse: () => throw Exception('Note not found'));
  }
}
