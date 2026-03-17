import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/models/category_model.dart';

class CategoryProvider {
  final ApiClient apiClient;

  CategoryProvider(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get('/categories');

    if (response.data == null) return [];
    
    final data = response.data['data'] ?? response.data;

    if (data is! List) return [];
    
    return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}