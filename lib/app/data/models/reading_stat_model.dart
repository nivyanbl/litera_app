class ReadingStatModel {
  final int? id;
  final int? userId;
  final int? productId;
  final int? accessCount;
  final String? firstAccessedAt;
  final String? lastAccessedAt;
  final ProductStat? product;

  ReadingStatModel({
    this.id,
    this.userId,
    this.productId,
    this.accessCount,
    this.firstAccessedAt,
    this.lastAccessedAt,
    this.product,
  });

  factory ReadingStatModel.fromJson(Map<String, dynamic> json) {
    return ReadingStatModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      productId: _parseInt(json['product_id']),
      accessCount: _parseInt(json['access_count']),
      firstAccessedAt: json['first_accessed_at']?.toString(),
      lastAccessedAt: json['last_accessed_at']?.toString(),
      product: json['product'] != null
          ? ProductStat.fromJson(json['product'])
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
}

class ProductStat {
  final int? id;
  final String? title;
  final String? author;
  final String? image;

  ProductStat({this.id, this.title, this.author, this.image});

  factory ProductStat.fromJson(Map<String, dynamic> json) {
    return ProductStat(
      id: _parseInt(json['id']),
      title: json['title']?.toString(),
      author: json['author']?.toString(),
      image: json['image']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }
}
