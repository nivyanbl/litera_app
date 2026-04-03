import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/providers/book_access_provider.dart';
import '../../../data/repositories/book_access_repository.dart';
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

    if (!Get.isRegistered<BookAccessProvider>()) {
      Get.lazyPut<BookAccessProvider>(
        () => BookAccessProvider(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<BookAccessRepository>()) {
      Get.lazyPut<BookAccessRepository>(
        () => BookAccessRepository(Get.find<BookAccessProvider>()),
      );
    }

    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(
        Get.find<CartRepository>(),
        Get.find<BookAccessRepository>(),
      ),
    );
  }
}
