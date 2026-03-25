import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/cart_provider.dart';
import 'package:litera/app/data/providers/checkout_provider.dart';
import 'package:litera/app/data/repositories/cart_repository.dart';
import 'package:litera/app/data/repositories/checkout_repository.dart';
import 'package:litera/app/modules/cart/controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartProvider>()) {
      Get.lazyPut<CartProvider>(
        () => CartProvider(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<CartRepository>()) {
      Get.lazyPut<CartRepository>(
        () => CartRepository(Get.find<CartProvider>()),
      );
    }

    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(
        () => CartController(Get.find<CartRepository>()),
      );
    }

    Get.lazyPut<CheckoutProvider>(() => CheckoutProvider());

    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepository(Get.find<CheckoutProvider>()),
    );

    Get.lazyPut<CheckoutController>(
      () => CheckoutController(Get.find<CheckoutRepository>()),
    );
  }
}