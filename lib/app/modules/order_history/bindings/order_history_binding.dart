import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/order_provider.dart';
import 'package:litera/app/data/repositories/order_repository.dart';

import '../controllers/order_history_controller.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderProvider>(() => OrderProvider(Get.find<ApiClient>()));
    Get.lazyPut<OrderRepository>(() => OrderRepository(Get.find()));
    Get.lazyPut<OrderHistoryController>(
      () => OrderHistoryController(repository: Get.find()),
    );
  }
}
