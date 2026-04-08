import '../models/category_model.dart';
import '../providers/category_provider.dart';

class CategoryRepository {
  final CategoryProvider categoryProvider;

  CategoryRepository({required this.categoryProvider});

  Future<List<CategoryModel>> getCategories() async {
    final result = await categoryProvider.getCategories();

    // Filter duplicate categories by id, keeping only the first occurrence
    final Map<int, CategoryModel> uniqueCategories = {};
    for (final category in result) {
      if (!uniqueCategories.containsKey(category.id)) {
        uniqueCategories[category.id] = category;
      }
    }

    return uniqueCategories.values.toList();
  }
}
