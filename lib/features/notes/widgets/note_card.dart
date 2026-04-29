import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';
import 'package:get/get.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onUpdateStatus;

  const NoteCard({
    super.key,
    required this.note,
    this.onEdit,
    this.onDelete,
    this.onUpdateStatus,
  });

  String get _formattedDate {
    return '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    final theme = Theme.of(context);

    return Card(
      color:
          note.status ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onLongPress: onUpdateStatus,
        onTap: onEdit,
        leading: Obx(() {
          final isUpdating =
              notesController.updatingStatusIds.contains(note.id);
          return Checkbox(
            value: note.status,
            onChanged: isUpdating ? null : (_) => onUpdateStatus?.call(),
          );
        }),
        title: Text(
          note.title,
          style: theme.textTheme.titleLarge?.copyWith(
            decoration: note.status ? TextDecoration.lineThrough : null,
            color: note.status
                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: note.status ? TextDecoration.lineThrough : null,
                color: note.status
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : null,
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.status)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Completed",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Created: $_formattedDate',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
