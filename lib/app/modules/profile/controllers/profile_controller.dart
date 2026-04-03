import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final title = 'Profile';
  final storage = GetStorage();

  Future<void> logout() async {
    try {
      // Clear all stored data
      await storage.erase();

      // Navigate to login page
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }
}
