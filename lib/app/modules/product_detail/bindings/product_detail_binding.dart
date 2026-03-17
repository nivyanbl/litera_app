import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/repositories/cart_repository.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartProvider>()) {
      Get.lazyPut<CartProvider>(() => CartProvider(Get.find<ApiClient>()));
    }

    if (!Get.isRegistered<CartRepository>()) {
      Get.lazyPut<CartRepository>(
        () => CartRepository(Get.find<CartProvider>()),
      );
    }

    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(Get.find<CartRepository>()),
    );
  }
}
