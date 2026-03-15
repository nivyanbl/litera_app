import 'product_model.dart';

class CartModel {
  final int id;
  final int userId;
  final int productId;
  final int quantity; 
  final ProductModel? product; 

  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    this.quantity = 1, 
    this.product,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      productId: json['product_id'],
      quantity: json['quantity'] ?? 1,
      product: json['product'] != null 
          ? ProductModel.fromJson(json['product']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}