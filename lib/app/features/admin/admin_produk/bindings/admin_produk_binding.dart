import 'package:get/get.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/providers/category_provider.dart';
import 'package:litera/app/data/providers/product_provider.dart';
import 'package:litera/app/data/repositories/category_repository.dart';
import 'package:litera/app/data/repositories/product_repository.dart';
import 'package:litera/app/features/admin/admin_produk/controllers/admin_produk_controller.dart';

class AdminProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());

    Get.lazyPut<ProductProvider>(() => ProductProvider(Get.find<ApiClient>()));
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(productProvider: Get.find<ProductProvider>()),
    );

    Get.lazyPut<CategoryProvider>(
      () => CategoryProvider(Get.find<ApiClient>()),
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(categoryProvider: Get.find<CategoryProvider>()),
    );

    Get.lazyPut<AdminProdukController>(
      () => AdminProdukController(
        Get.find<ProductRepository>(),
        Get.find<CategoryRepository>(),
      ),
    );
  }
}