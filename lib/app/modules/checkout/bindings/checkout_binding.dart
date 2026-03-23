import 'package:get/get.dart';
import 'package:litera/app/data/providers/checkout_provider.dart';
import 'package:litera/app/data/repositories/checkout_repository.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutProvider>(() => CheckoutProvider());
    
    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepository(Get.find<CheckoutProvider>())
    );
    
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(Get.find<CheckoutRepository>())
    );
  }
}