import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../../data/providers/profile_provider.dart';
import '../../../../data/repositories/profile_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Provider - menggunakan ApiClient yang sudah di-configure
    Get.lazyPut<ProfileProvider>(() => ProfileProvider(Get.find()));

    // Inject Repository yang membutuhkan Provider
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(provider: Get.find()),
    );

    // Inject Controller yang membutuhkan Repository
    Get.lazyPut<ProfileController>(
      () => ProfileController(repository: Get.find()),
    );
  }
}
