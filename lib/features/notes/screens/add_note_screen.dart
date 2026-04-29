import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/controllers/loading_controller.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';
import 'package:flutter_ui/shared/app_button.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:get/get.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final _loading = Get.find<LoadingController>();
  final _notes = Get.find<NotesController>();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final desc = descController.text;
    final status = false;

    if (title.isEmpty || desc.isEmpty) {
      SnackBarHelper.showError(context, 'Please enter title and description');
      return;
    }

    await _loading.runWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      await _notes.addNote(title, desc, status);
    });

    if (!mounted) return;
    Navigator.pop(context, 'Note added successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Content',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Obx(
              () => AppButton(
                onPressed: _loading.isLoading.value ? null : saveNote,
                text: _loading.isLoading.value ? 'Loading...' : 'Add Note',
                fontSize: 18,
                paddingHorizontal: 30,
                paddingVertical: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
