import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductRepository {
  final ProductProvider productProvider;

  ProductRepository({required this.productProvider});

  Future<List<ProductModel>> getProducts({
    String? search,
    int? categoryId,
    String? sort,
    bool? onlyAvailable,
  }) async {
    return await productProvider.getProducts(
      search: search,
      categoryId: categoryId,
      sort: sort,
      onlyAvailable: onlyAvailable,
    );
  }

  Future<ProductModel> getProductDetail(String idOrSlug) async {
    return await productProvider.getProductDetail(idOrSlug);
  }

  Future<bool> checkOwnership(int productId) async {
    return await productProvider.checkOwnership(productId);
  }

  Future<ProductModel> createProduct(
    ProductModel product, {
    File? imageFile,
    PlatformFile? pdfFile,
  }) async {
    final formData = await _buildFormData(
      product,
      imageFile: imageFile,
      pdfFile: pdfFile,
    );

    final response = await productProvider.createProduct(formData);
    return ProductModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<ProductModel> updateProduct(
    ProductModel product, {
    File? imageFile,
    PlatformFile? pdfFile,
  }) async {
    final formData = await _buildFormData(
      product,
      imageFile: imageFile,
      pdfFile: pdfFile,
    );

    final response = await productProvider.updateProduct(product.id, formData);
    return ProductModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> deleteProduct(int id) async {
    await productProvider.deleteProduct(id);
  }

  Future<FormData> _buildFormData(
    ProductModel product, {
    File? imageFile,
    PlatformFile? pdfFile,
  }) async {
    final map = <String, dynamic>{
      'category_id': product.categoryId,
      'title': product.title,
      'slug': product.slug,
      'price': product.price,
      'description': product.description ?? '',
      'stock': product.stock,
      'author': product.author,
      'language': product.language,
      'pages': product.pages,
      'published_at': product.publishedAt,
    };

    if (imageFile != null) {
      map['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    if (pdfFile != null && pdfFile.path != null) {
      map['file_book'] = await MultipartFile.fromFile(
        pdfFile.path!,
        filename: pdfFile.name,
      );
    }

    return FormData.fromMap(map);
  }
}
