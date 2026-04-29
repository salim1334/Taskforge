import 'package:flutter_ui/core/storage/local_storage.dart';
import 'package:flutter_ui/features/notes/models/note.dart';

enum SortType { newest, oldest }

class NotesRepository {
  final _db = NotesDatabaseService.instance;

  static const String _sortTypeKey = 'sort_type';
  static const String _searchQueryKey = 'search_query';

  Future<List<Note>> loadNotes() async {
    return _db.getAllNotes();
  }

  Future<SortType> loadSortType() async {
    final value = await _db.getSetting(_sortTypeKey);
    if (value == null) return SortType.newest;
    return SortType.values[int.parse(value)];
  }

  Future<void> saveSortType(SortType type) async {
    await _db.setSetting(_sortTypeKey, type.index.toString());
  }

  Future<String> loadSearchQuery() async {
    return (await _db.getSetting(_searchQueryKey)) ?? '';
  }

  Future<void> saveSearchQuery(String query) async {
    await _db.setSetting(_searchQueryKey, query);
  }

  Note getNoteById(int id, List<Note> notes) {
    return notes.firstWhere(
      (note) => note.id == id,
      orElse: () => throw Exception('Note not found'),
    );
  }

  // Create
  Future<void> addNote(String title, String content, bool status) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      content: content,
      status: status,
      createdAt: DateTime.now(),
    );
    await _db.insertNote(note);
  }

  // Update
  Future<void> updateNote(
      int id, String title, String content, List<Note> notes) async {
    final index = notes.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final updated = Note(
      id: id,
      title: title,
      content: content,
      status: notes[index].status,
      createdAt: notes[index].createdAt,
    );
    await _db.updateNote(updated);
  }

  // Delete
  Future<void> deleteNoteById(int id) async {
    await _db.deleteNote(id);
  }

  // Clear All
  Future<void> clearAllNotes() async {
    await _db.deleteAllNotes();
  }

  // Update Task Status
  Future<void> updateTaskStatus(int id, bool newStatus) async {
    await _db.updateNoteStatus(id, newStatus);
  }
}
