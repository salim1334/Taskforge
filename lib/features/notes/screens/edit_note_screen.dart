import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/providers/loading_provider.dart';
import 'package:flutter_ui/shared/app_button.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, this.id});

  final int? id;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotesProvider>();
      final note = provider.getNoteById(widget.id!);

      titleController.text = note.title;
      descController.text = note.content;
    });
  }

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
      showErrorSnackBar(context, "Please enter title and description");
      return;
    }

    await context.read<LoadingProvider>().runWithLoading(() async {
      await Future.delayed(const Duration(seconds: 2));

      context.read<NotesProvider>().updateNote(
            widget.id!,
            title,
            desc,
          );
    });

    if (!mounted) return;
    Navigator.pop(context, "Note updated successfully");
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<LoadingProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: loading ? null : saveNote,
              text: loading ? "Loading..." : "Edit Note",
              color: Colors.green,
              fontSize: 18,
              paddingHorizontal: 30,
              paddingVertical: 15,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
