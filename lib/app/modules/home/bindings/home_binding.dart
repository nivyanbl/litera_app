import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductProvider>(() => ProductProvider(Get.find<ApiClient>()));

    Get.lazyPut<ProductRepository>(
      () => ProductRepository(productProvider: Get.find<ProductProvider>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductRepository>()),
    );
  }
}
