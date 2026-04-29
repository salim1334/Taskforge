import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> runWithLoading(Future<void> Function() task) async {
    try {
      isLoading.value = true;
      await task();
    } catch (e) {
      print('Error during loading operation: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
