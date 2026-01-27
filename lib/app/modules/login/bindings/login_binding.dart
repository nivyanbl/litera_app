import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetStorage(), fenix: true);

    Get.lazyPut(() => ApiClient(), fenix: true);
    Get.lazyPut(() => AuthProvider(Get.find<ApiClient>()), fenix: true);

    Get.lazyPut(
      () => AuthRepository(Get.find<AuthProvider>(), Get.find<GetStorage>()),
      fenix: true,
    );

    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
  }
}
