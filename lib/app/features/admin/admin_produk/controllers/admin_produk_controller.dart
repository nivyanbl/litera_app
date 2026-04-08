import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/data/models/category_model.dart';
import 'package:litera/app/data/models/product_model.dart';
import 'package:litera/app/data/repositories/category_repository.dart';
import 'package:litera/app/data/repositories/product_repository.dart';

class AdminProdukController extends GetxController {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  AdminProdukController(this._productRepository, this._categoryRepository);

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;

  final searchQuery = ''.obs;
  final selectedCategoryId = RxnInt();
  final selectedSort = 'newest'.obs;
  final onlyAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();

    debounce(
      searchQuery,
      (_) => fetchProducts(),
      time: const Duration(milliseconds: 500),
    );
    ever(selectedCategoryId, (_) => fetchProducts());
    ever(selectedSort, (_) => fetchProducts());
    ever(onlyAvailable, (_) => fetchProducts());

    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _categoryRepository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorNormal,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final result = await _productRepository.getProducts(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
        sort: selectedSort.value,
        onlyAvailable: onlyAvailable.value,
      );
      products.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorNormal,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteProduct(int id) async {
    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete this product?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();

        try {
          isLoading(true);
          await _productRepository.deleteProduct(id);
          products.removeWhere((p) => p.id == id);

          Get.snackbar(
            'Success',
            'Product deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.successNormal,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Failed to delete product: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorNormal,
            colorText: Colors.white,
          );
        } finally {
          isLoading(false);
        }
      },
    );
  }

  Future<void> saveProduct(
    ProductModel product, {
    File? imageFile,
    PlatformFile? pdfFile,
  }) async {
    try {
      isLoading(true);
      if (product.id == 0) {
        await _productRepository.createProduct(
          product,
          imageFile: imageFile,
          pdfFile: pdfFile,
        );
      } else {
        await _productRepository.updateProduct(
          product,
          imageFile: imageFile,
          pdfFile: pdfFile,
        );
      }

      await fetchProducts();
      Get.back();

      Get.snackbar(
        'Success',
        product.id == 0
            ? 'Product created successfully'
            : 'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successNormal,
        colorText: Colors.white,
      );
    } catch (e) {
      String errorMsg = e.toString();

      Get.snackbar(
        'Error',
        'Failed to save product:\n$errorMsg',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorNormal,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }
}
