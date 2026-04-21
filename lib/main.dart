import 'package:flutter/material.dart';
import 'package:flutter_ui/features/notes/providers/loading_provider.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/notes/providers/notes_provider.dart';
import 'features/notes/screens/notes_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
