import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/data/models/cart_model.dart';

class CartProvider {
  final ApiClient apiClient;

  CartProvider(this.apiClient);

  //GET
  Future<List<CartModel>> getCarts() async {
    final response = await apiClient.get('/carts');

    if (response.data == null) return [];
    final data = response.data['data'] ?? response.data;

    if (data is! List) return [];
    return data.map((e) => CartModel.fromJson(e as Map<String, dynamic>)).toList();

  }

  //POST
  Future<void> addToCart(int productId) async {
    await apiClient.post('/carts', data: {
      'product_id': productId,
    });
  }

  //DELETE
  Future<void> deleteCart(int id) async {
    await apiClient.delete('/carts/$id');
  }
}