import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../data/repository/notes_repository.dart';
import '../models/note.dart';

class NotesController extends GetxController {
  final NotesRepository _repository = NotesRepository();

  final RxList<Note> notes = <Note>[].obs;
  final Rx<SortType> sortType = SortType.newest.obs;
  final RxString searchQuery = ''.obs;
  final RxSet<int> updatingStatusIds = <int>{}.obs;

  List<Note> get filteredNotes {
    List<Note> result;

    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) {
      result = List.from(notes);
    } else {
      result = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    }

    if (sortType.value == SortType.newest) {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return result;
  }

  Note getNoteById(int id) => _repository.getNoteById(id, notes);

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final loadedNotes = await _repository.loadNotes();
    notes.assignAll(loadedNotes);

    final savedSort = await _repository.loadSortType();
    sortType.value = savedSort;

    final savedQuery = await _repository.loadSearchQuery();
    searchQuery.value = savedQuery;
  }

  Future<void> setSortType(SortType type) async {
    sortType.value = type;
    await _repository.saveSortType(type);
  }

  Future<void> addNote(String title, String content, bool status) async {
    await _repository.addNote(title, content, status);
    final loadedNotes = await _repository.loadNotes();
    notes.assignAll(loadedNotes);
  }

  Future<void> updateNote(int id, String title, String content) async {
    await _repository.updateNote(id, title, content, notes);
    final loadedNotes = await _repository.loadNotes();
    notes.assignAll(loadedNotes);
  }

  Future<void> deleteNoteById(int id) async {
    await _repository.deleteNoteById(id);
    notes.removeWhere((n) => n.id == id);
  }

  Future<void> clearAllNotes() async {
    await _repository.clearAllNotes();
    notes.clear();
  }

  Future<void> setSearchQuery(String query) async {
    searchQuery.value = query.toLowerCase().trim();
    await _repository.saveSearchQuery(searchQuery.value);
  }

  Future<void> updateStatus(int id, bool currentStatus) async {
    // Prevent duplicate updates
    if (updatingStatusIds.contains(id)) return;

    try {
      updatingStatusIds.add(id);

      final newStatus = !currentStatus;
      await _repository.updateTaskStatus(id, newStatus);

      // Update only the specific note in the list
      final index = notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        final oldNote = notes[index];
        notes[index] = Note(
          id: oldNote.id,
          title: oldNote.title,
          content: oldNote.content,
          status: newStatus,
          createdAt: oldNote.createdAt,
        );
        notes.refresh(); // Trigger UI update
      }
    } catch (e) {
      print('Failed to update status: $e');
      // You need Get.context or pass context as parameter to show SnackBar
      if (Get.context != null) {
        SnackBarHelper.showError(Get.context!, 'Failed to update status');
      }
    } finally {
      updatingStatusIds.remove(id);
    }
  }
}
