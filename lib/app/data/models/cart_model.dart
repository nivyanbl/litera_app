import 'product_model.dart';

class CartModel {
  final int? id;
  final int userId;
  final int productId;
  final int quantity;
  final ProductModel? product;
  bool isSelected;

  CartModel({
    this.id,
    required this.userId,
    required this.productId,
    this.quantity = 1,
    this.product,
    this.isSelected = false,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      productId: _parseInt(json['product_id']),
      quantity: _parseInt(json['quantity']),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
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
