import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductProvider {
  final ApiClient apiClient;

  ProductProvider(this.apiClient);

  // Ambil daftar produk dengan opsi pencarian dan kategori
  Future<List<ProductModel>> getProducts({String? search, int? categoryId}) async {
    final response = await apiClient.get(
      '/products',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null) 'category_id': categoryId,
      },
    );

    if (response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }
    return [];
  }

  // Ambil detail produk berdasarkan ID atau slug
  Future<ProductModel> getProductDetail(String idOrSlug) async {
    final response = await apiClient.get('/products/$idOrSlug');
    
    return ProductModel.fromJson(response.data['data']);
  }
}