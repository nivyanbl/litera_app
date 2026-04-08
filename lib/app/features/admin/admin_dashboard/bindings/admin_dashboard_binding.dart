import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/admin_dashboard_provider.dart';
import 'package:litera/app/data/repositories/admin_dashboard_repository.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient());
    }

    Get.lazyPut<AdminDashboardProvider>(
      () => AdminDashboardProvider(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<AdminDashboardRepository>(
      () =>
          AdminDashboardRepository(provider: Get.find<AdminDashboardProvider>()),
    );

    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(
        repository: Get.find<AdminDashboardRepository>(),
      ),
    );
  }
}