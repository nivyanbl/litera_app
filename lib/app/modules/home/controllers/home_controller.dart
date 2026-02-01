import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository repository;
  HomeController(this.repository);

  var isLoading = true.obs;
  var productList = <ProductModel>[].obs;

  final searchController = TextEditingController();
  Timer? _debounce;

  var currentBannerIndex = 0.obs;
  void onBannerChanged(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // Fungsi Ambil Data Produk
  Future<void> fetchProducts({String? query}) async {
    try {
      isLoading(true);
      final products = await repository.getProducts(search: query);
      productList.assignAll(products);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi Search dengan Debounce
  void onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      fetchProducts(query: val);
    });
  }

  // Fungsi Refresh
  Future<void> refreshData() async {
    searchController.clear();
    await fetchProducts();
  }
}
