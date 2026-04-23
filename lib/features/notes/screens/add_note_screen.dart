import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/providers/loading_provider.dart';
import 'package:flutter_ui/shared/app_button.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final desc = descController.text;

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      SnackBarHelper.showError(context, "Please enter title and description");
      return;
    }

    await context.read<LoadingProvider>().runWithLoading(() async {
      await Future.delayed(const Duration(seconds: 2));

      context.read<NotesProvider>().addNote(title, desc);
    });

    if (!mounted) return;
    Navigator.pop(context, "Note added successfully");
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<LoadingProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Content",
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: loading ? null : saveNote,
              text: loading ? "Loading..." : "Add Note",
              fontSize: 18,
              paddingHorizontal: 30,
              paddingVertical: 15,
            ),
          ],
        ),
      ),
    );
  }
}
