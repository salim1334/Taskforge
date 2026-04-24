import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NotesSearchField extends StatelessWidget {
  final TextEditingController controller;

  const NotesSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: (value) =>
            context.read<NotesProvider>().setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Search notes...',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}