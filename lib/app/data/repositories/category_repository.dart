import '../models/category_model.dart';
import '../providers/category_provider.dart';

class CategoryRepository {
  final CategoryProvider categoryProvider;

  CategoryRepository(this.categoryProvider);

  Future<List<CategoryModel>> getCategories() async {
    return await categoryProvider.getCategories();
  }
}