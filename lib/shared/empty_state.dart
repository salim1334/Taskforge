import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key,
      required this.message,
      required this.subMessage,
      required this.icon,
      this.iconColor = Colors.grey,
      this.iconSize = 80,
      this.fontSize = 18});

  final String message;
  final String subMessage;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            subMessage,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
