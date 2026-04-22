import '../models/note.dart';

class NotesController {
  final List<Note> _notes = [
    Note(
      id: 1, 
      title: 'Flutter', 
      content: 'Learn clean architecture',
      createdAt: DateTime.now(),
    ),
    Note(
      id: 2, 
      title: 'Backend', 
      content: 'Connect Node.js API',
      createdAt: DateTime.now(),
    ),
    Note(
      id: 3, 
      title: 'Firebase', 
      content: 'Push notifications',
      createdAt: DateTime.now(),
    ),
  ];

  String _searchQuery = '';

  List<Note> get notes => _notes;

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    return _notes.where((note) => 
      note.title.toLowerCase().contains(_searchQuery) || 
      note.content.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  Note getNoteById(int id) => _notes.firstWhere((note) => note.id == id);

  void addNote(String title, String content) {
    _notes.insert(
        0,
        Note(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title,
          content: content,
          createdAt: DateTime.now(),
        ));
  }

  void updateNote(int id, String title, String content) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final oldNote = _notes[index];
      _notes[index] = Note(
        id: id, 
        title: title, 
        content: content,
        createdAt: oldNote.createdAt,
      );
    }
  }

  void deleteNoteById(int id) {
    _notes.removeWhere((note) => note.id == id);
  }

  void deleteNote(Note note) {
    _notes.remove(note);
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
  }
}
