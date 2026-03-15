import '../models/cart_model.dart';
import '../providers/cart_provider.dart';

class CartRepository {
  final CartProvider cartProvider;

  CartRepository({required this.cartProvider});

  Future<List<CartModel>> getCarts() async {
    return await cartProvider.getCarts();
  }

  Future<void> addToCart(int productId) async {
    return await cartProvider.addToCart(productId);
  }

  Future<void> deleteCart(int id) async {
    return await cartProvider.deleteCart(id);
  }
}