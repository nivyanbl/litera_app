import 'package:get/get.dart';
import 'package:litera/app/data/models/category_model.dart';
import 'package:litera/app/data/repositories/category_repository.dart';
import 'package:litera/app/modules/home/controllers/home_controller.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository;
  CategoryController(this.repository);

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = true.obs;
  
  final RxnInt selectedCategoryId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void selectCategory(int? id) {
    if (selectedCategoryId.value == id) {
      selectedCategoryId.value = null;
    } else {
      selectedCategoryId.value = id;
    }
    
    Get.find<HomeController>().fetchProducts(
      categoryId: selectedCategoryId.value
    );
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await repository.getCategories();
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    } finally {
      isLoading.value = false;
    }
  }
}