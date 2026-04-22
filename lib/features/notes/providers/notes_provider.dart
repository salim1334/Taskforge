import 'package:flutter/material.dart';
import '../models/note.dart';
import '../controllers/notes_controller.dart';

class NotesProvider extends ChangeNotifier {
  final NotesController _controller = NotesController();

  List<Note> get notes => _controller.notes;

  List<Note> get filteredNotes => _controller.filteredNotes;

  Note getNoteById(int id) => _controller.getNoteById(id);

  void addNote(String title, String content) {
    _controller.addNote(title, content);
    notifyListeners();
  }

  void updateNote(int id, String title, String content) {
    _controller.updateNote(id, title, content);
    notifyListeners();
  }

  void deleteNoteById(int id) {
    _controller.deleteNoteById(id);
    notifyListeners();
  }

  void deleteNote(Note note) {
    _controller.deleteNote(note);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _controller.setSearchQuery(query);
    notifyListeners();
  }
}
