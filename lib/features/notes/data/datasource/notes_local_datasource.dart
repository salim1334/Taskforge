import '../../models/note.dart';

class NotesLocalDataSource {
  final List<Note> _notes = [];

  List<Note> getNotes() => _notes;

  void addNote(Note note) {
    _notes.insert(0, note);
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
    }
  }

  void deleteNote(int id) {
    _notes.removeWhere((note) => note.id == id);
  }
}
