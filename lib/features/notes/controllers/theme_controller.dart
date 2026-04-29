import 'package:get/get.dart';
import '../../../core/storage/local_storage.dart';

class ThemeController extends GetxController {
  static const String _key = 'isDarkMode';
  // first fetch the system team if there's no saved data
  final RxBool isDarkMode = Get.isPlatformDarkMode.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final value = await NotesDatabaseService.instance.getSetting(_key);
    isDarkMode.value = value == 'true';
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await NotesDatabaseService.instance
        .setSetting(_key, isDarkMode.value.toString());
  }
}
