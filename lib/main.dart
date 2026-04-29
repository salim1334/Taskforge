import 'package:flutter/material.dart';
import 'package:flutter_ui/core/theme/app_theme.dart';
import 'package:flutter_ui/features/notes/controllers/loading_controller.dart';
import 'package:flutter_ui/features/notes/controllers/notes_controller.dart';
import 'package:flutter_ui/features/notes/controllers/theme_controller.dart';
import 'package:flutter_ui/features/notes/screens/notes_home_screen.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ThemeController());
  Get.put(NotesController());
  Get.put(LoadingController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Flutter Notes App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: const NotesHomeScreen(),
      ),
    );
  }
}
