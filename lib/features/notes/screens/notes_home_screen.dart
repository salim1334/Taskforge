import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';
import 'package:flutter_ui/features/notes/controllers/theme_controller.dart';
import 'package:flutter_ui/features/notes/data/repository/notes_repository.dart';
import 'package:flutter_ui/features/notes/models/note.dart';
import 'package:flutter_ui/features/notes/screens/add_note_screen.dart';
import 'package:flutter_ui/features/notes/screens/edit_note_screen.dart';
import 'package:flutter_ui/features/notes/widgets/debounced_search_field.dart';
import 'package:flutter_ui/shared/empty_state.dart';
import 'package:flutter_ui/shared/search_empty_state.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:get/get.dart';

import '../widgets/note_card.dart';

class NotesHomeScreen extends StatelessWidget {
  const NotesHomeScreen({super.key});

  NotesController get _notes => Get.find<NotesController>();
  ThemeController get _theme => Get.find<ThemeController>();

  Future<void> _openAddNoteScreen(BuildContext context) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    _showResult(context, message);
  }

  Future<void> _openEditNoteScreen(BuildContext context, int noteId) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditNoteScreen(id: noteId)),
    );

    _showResult(context, message);
  }

  void _showResult(BuildContext context, String? message) {
    if (message == null) return;
    SnackBarHelper.showSuccess(context, message);
  }

  void _deleteNote(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${note.title}"'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _notes.deleteNoteById(note.id);
              SnackBarHelper.showSuccess(context, 'Note deleted successfully');
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearAllNotes(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notes?'),
        content: const Text(
            'Are you sure you want to delete all notes? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _notes.clearAllNotes();
              SnackBarHelper.showSuccess(context, 'All notes cleared');
              Navigator.pop(ctx);
            },
            child:
                const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            // Sort toggle
            Obx(() {
              final sort = _notes.sortType.value;
              return IconButton(
                icon: Icon(sort == SortType.newest
                    ? Icons.arrow_downward
                    : Icons.arrow_upward),
                tooltip: sort == SortType.newest ? 'Newest first' : 'Oldest first',
                onPressed: () => _notes.setSortType(
                  sort == SortType.newest ? SortType.oldest : SortType.newest,
                ),
              );
            }),
            // Clear all
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all notes',
              onPressed: () => _clearAllNotes(context),
            ),
            // Theme toggle
            Obx(() => IconButton(
                  icon: Icon(_theme.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode),
                  onPressed: _theme.toggleTheme,
                )),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DebouncedSearchField(
                onSearch: (value) => _notes.setSearchQuery(value),
              ),
            ),
            Expanded(
              child: Obx(() {
                final allNotes = _notes.notes;
                final filtered = _notes.filteredNotes;

                if (allNotes.isEmpty) {
                  return EmptyState(
                    message: 'No tasks yet',
                    subMessage: 'Tap + to add a task',
                    icon: Icons.inbox,
                  );
                }

                if (filtered.isEmpty) {
                  return SearchEmptyState(
                      query: _notes.searchQuery.value);
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final note = filtered[index];
                    return NoteCard(
                      note: note,
                      onDelete: () => _deleteNote(context, note),
                      onEdit: () => _openEditNoteScreen(context, note.id),
                      onUpdateStatus: () => _notes.updateStatus(note.id, note.status),
                    );
                  },
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddNoteScreen(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
