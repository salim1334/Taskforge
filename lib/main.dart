import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/notes/screens/notes_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mastery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const NotesHomeScreen(),
    );
  }
}
