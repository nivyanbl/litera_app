import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/order_provider.dart';
import 'package:litera/app/data/repositories/order_repository.dart';
import 'package:litera/app/features/admin/admin_orders/controllers/admin_orders_controller.dart';

class AdminOrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient());
    }

    if (!Get.isRegistered<OrderProvider>()) {
      Get.lazyPut<OrderProvider>(
        () => OrderProvider(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<OrderRepository>()) {
      Get.lazyPut<OrderRepository>(
        () => OrderRepository(Get.find<OrderProvider>()),
      );
    }

    // Don't use lazyPut for controller - needs to be fresh for every route
    Get.put<AdminOrdersController>(
      AdminOrdersController(
        repository: Get.find<OrderRepository>(),
      ),
    );
  }
}
