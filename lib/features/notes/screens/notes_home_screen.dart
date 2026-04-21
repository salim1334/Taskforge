import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/models/note.dart';
import 'package:flutter_ui/features/notes/providers/notes_provider.dart';
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
  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> openAddNoteScreen() async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddNoteScreen(),
      ),
    );

    showResultMessage(message);
  }

  Future<void> openEditNoteScreen(int noteId) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => EditNoteScreen(id: noteId),
      ),
    );

    showResultMessage(message);
  }

  void showResultMessage(String? message) {
    if (message == null || !mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    showSuccessSnackBar(context, message);
  }

  void deleteNote(Note note, int index) {
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

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              showSuccessSnackBar(context, "Note deleted successfully");

              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, child) {
          final notes = provider.notes;

          if (notes.isEmpty) {
            return EmptyState(
              message: 'No tasks yet',
              subMessage: 'Tap + to add a task',
              icon: Icons.inbox,
            );
          }

          return Column(
            children: [
              // Search input
              
              const SizedBox(height: 20),
              ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return NoteCard(
                title: note.title,
                content: note.content,
                onDelete: () => deleteNote(note, index),
                onEdit: () => openEditNoteScreen(note.id),
              );
            },
          ),
            ],
          );
        },
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
