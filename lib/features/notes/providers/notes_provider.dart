import 'package:flutter/material.dart';

import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [
    Note(id: 1, title: 'Flutter', content: 'Learn clean architecture'),
    Note(id: 2, title: 'Backend', content: 'Connect Node.js API'),
    Note(id: 3, title: 'Firebase', content: 'Push notifications'),
  ];

  List<Note> get notes => _notes;

  void addNote(String title, String content) {
    _notes.insert(
        0,
        Note(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title,
          content: content,
        ));
    notifyListeners();
  }

  // Update note
  void updateNote(int id, String title, String content) {
    final index = _notes.indexWhere((note) => note.id == id);

    if (index != -1) {
      _notes[index] = Note(id: id, title: title, content: content);
      notifyListeners();
    }
  }

  // Delete Note By Id
  void deleteNoteById(int id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  // give notes according to id
  Note getNoteById(int id) => _notes.firstWhere((note) => note.id == id);
}
