import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';

class NotesSearchField extends StatelessWidget {
  final TextEditingController controller;

  const NotesSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final noteController = Get.find<NotesController>();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          noteController.setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search notes...',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}