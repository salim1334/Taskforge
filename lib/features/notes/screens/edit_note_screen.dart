import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/controllers/loading_controller.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';
import 'package:flutter_ui/shared/app_button.dart';
import 'package:flutter_ui/utils/snackbar_helper.dart';
import 'package:get/get.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, this.id});

  final int? id;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final _loading = Get.find<LoadingController>();
  final _notes = Get.find<NotesController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final note = _notes.getNoteById(widget.id!);
        titleController.text = note.title;
        descController.text = note.content;
      } catch (e) {
        // Note not found — stay blank
      }
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
      SnackBarHelper.showError(context, 'Please enter title and description');
      return;
    }

    await _loading.runWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      await _notes.updateNote(widget.id!, title, desc);
    });

    if (!mounted) return;
    Navigator.pop(context, 'Note updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            Obx(() => AppButton(
                  onPressed: _loading.isLoading.value ? null : saveNote,
                  text:
                      _loading.isLoading.value ? 'Loading...' : 'Edit Note',
                  color: Colors.green,
                  fontSize: 18,
                  paddingHorizontal: 30,
                  paddingVertical: 15,
                  textColor: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
