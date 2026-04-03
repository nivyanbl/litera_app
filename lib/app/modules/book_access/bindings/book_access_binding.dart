import 'package:get/get.dart';
import 'package:litera/app/modules/book_access/controllers/book_access_controller.dart';
import 'package:litera/app/data/providers/book_access_provider.dart';
import 'package:litera/app/data/repositories/book_access_repository.dart';
import 'package:litera/app/core/network/api_client.dart';

class BookAccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    
    Get.lazyPut<BookAccessProvider>(() => BookAccessProvider(Get.find<ApiClient>()));
    Get.lazyPut<BookAccessRepository>(() => BookAccessRepository(Get.find<BookAccessProvider>()));
    Get.lazyPut<BookAccessController>(() => BookAccessController(Get.find<BookAccessRepository>()));
  }
}