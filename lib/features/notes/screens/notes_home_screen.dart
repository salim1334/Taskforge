import 'package:flutter/material.dart';
import '../widgets/note_card.dart';

class NotesHomeScreen extends StatelessWidget {
  const NotesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = [
      {'title': 'Flutter', 'content': 'Learn clean architecture'},
      {'title': 'Backend', 'content': 'Connect Node.js API'},
      {'title': 'Firebase', 'content': 'Push notifications'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(
            title: note['title']!,
            content: note['content']!,
          );
        },
      ),
    );
  }
}
