class ProductModel {
  final int id;
  final int categoryId;
  final String title;
  final String slug;
  final double price;
  final String? description;
  final String? fileBook;
  final int stock;
  final String? image;
  final String author;
  final String language;
  final String pages;
  final String publishedAt;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.price,
    this.description,
    this.fileBook,
    required this.stock,
    this.image,
    required this.author,
    required this.language,
    required this.pages,
    required this.publishedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'],
      fileBook: json['file_book'],
      stock: json['stock'] ?? 0,
      image: json['image'],
      author: json['author'] ?? '',
      language: json['language'] ?? '',
      pages: json['pages'] ?? '',
      publishedAt: json['published_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'file_book': fileBook,
      'stock': stock,
      'image': image,
      'author': author,
      'language': language,
      'pages': pages,
      'published_at': publishedAt,
    };
  }
}
