import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    required this.subMessage,
    required this.icon,
    this.iconColor,
    this.iconSize = 80,
    this.fontSize = 18,
  });

  final String message;
  final String subMessage;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Text(
            subMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
