import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String content;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }
}
