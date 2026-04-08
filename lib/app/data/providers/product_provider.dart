import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductProvider {
  final ApiClient apiClient;

  ProductProvider(this.apiClient);

  Future<List<ProductModel>> getProducts({
    String? search,
    int? categoryId,
    String? sort,
    bool? onlyAvailable,
  }) async {
    final response = await apiClient.get(
      '/products',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null) 'category_id': categoryId,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
        if (onlyAvailable == true) 'only_available': 1,
      },
    );

    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map<ProductModel>(
          (e) => ProductModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<ProductModel> getProductDetail(String idOrSlug) async {
    final response = await apiClient.get('/products/$idOrSlug');
    return ProductModel.fromJson(response.data['data']);
  }

  Future<Response<dynamic>> createProduct(FormData data) {
    return apiClient.post('/products', data: data);
  }

  Future<Response<dynamic>> updateProduct(int id, FormData data) {
    return apiClient.post('/products/$id', data: data);
  }

  Future<Response<dynamic>> deleteProduct(int id) {
    return apiClient.delete('/products/$id');
  }

  Future<bool> checkOwnership(int productId) async {
    try {
      final response = await apiClient.get('/products/$productId/ownership');
      return response.data['is_owned'] ?? false;
    } catch (_) {
      return false;
    }
  }
}