import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/models/note.dart';
import 'package:flutter_ui/features/notes/providers/notes_provider.dart';
import 'package:flutter_ui/features/notes/providers/theme_provider.dart';
import 'package:flutter_ui/features/notes/screens/add_note_screen.dart';
import 'package:flutter_ui/features/notes/screens/edit_note_screen.dart';
import 'package:flutter_ui/shared/empty_state.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';

import '../widgets/note_card.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> openAddNoteScreen() async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    showResultMessage(message);
  }

  Future<void> openEditNoteScreen(int noteId) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => EditNoteScreen(id: noteId)),
    );
    showResultMessage(message);
  }

  void showResultMessage(String? message) {
    if (message == null || !mounted) return;
    
    SnackBarHelper.showSuccess(context, message);
  }

  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${note.title}"'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesProvider>().deleteNoteById(note.id);
              
              SnackBarHelper.showSuccess(context, "Note deleted successfully");
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () => context.read<ThemeProvider>().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input UI
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                provider.setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).iconTheme.color),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: Theme.of(context).iconTheme.color),
                        onPressed: () {
                          searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),

          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, notesProvider, child) {
                final allNotes = notesProvider.notes;
                final filteredNotes = notesProvider.filteredNotes;

                if (allNotes.isEmpty) {
                  return EmptyState(
                    message: 'No tasks yet',
                    subMessage: 'Tap + to add a task',
                    icon: Icons.inbox,
                  );
                }

                if (filteredNotes.isEmpty) {
                  return Center(
                    child: Text(
                        'No notes found matching => ${searchController.text}'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return NoteCard(
                      note: note,
                      onDelete: () => deleteNote(note),
                      onEdit: () => openEditNoteScreen(note.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddNoteScreen,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
