import '../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryProvider {
  final ApiClient apiClient;

  CategoryProvider(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get('/categories');
    final List<dynamic> data = response.data['data'] ?? [];

    return data
        .map<CategoryModel>(
          (e) => CategoryModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}