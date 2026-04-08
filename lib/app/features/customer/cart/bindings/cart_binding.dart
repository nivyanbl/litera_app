import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/cart_provider.dart';
import 'package:litera/app/data/repositories/cart_repository.dart';
import 'package:litera/app/features/customer/cart/controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartProvider>(
      () => CartProvider(Get.find<ApiClient>()),
    );
    Get.lazyPut<CartRepository>(
      () => CartRepository(Get.find<CartProvider>()),
    );
    Get.lazyPut<CartController>(
      () => CartController(Get.find<CartRepository>()),
    );
  }
}