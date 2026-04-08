class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final int? parentId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      parentId: _parseInt(json['parent_id']),
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
    return {'id': id, 'name': name, 'slug': slug, 'parent_id': parentId};
  }
}
