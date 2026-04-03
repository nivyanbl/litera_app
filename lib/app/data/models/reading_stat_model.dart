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
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      accessCount: json['access_count'],
      firstAccessedAt: json['first_accessed_at'],
      lastAccessedAt: json['last_accessed_at'],
      product: json['product'] != null ? ProductStat.fromJson(json['product']) : null,
    );
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
      id: json['id'],
      title: json['title'],
      author: json['author'],
      image: json['image'],
    );
  }
}