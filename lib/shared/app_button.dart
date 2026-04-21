import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onPressed,
    this.text = 'Press Me',
    this.color = Colors.blue,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.paddingHorizontal = 20,
    this.paddingVertical = 10,
  });

  final String text;
  final Color color;
  final double fontSize;
  final Color textColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
