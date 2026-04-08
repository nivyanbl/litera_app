import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/features/admin/admin_produk/controllers/admin_produk_controller.dart';
import '../widgets/product_filter_section.dart';
import '../widgets/product_card.dart';
import '../widgets/product_empty_state.dart';
import 'product_form_view.dart';

class ProductListView extends GetView<AdminProdukController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          // Modern Sliver App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Products',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFF8F9FE)],
                  ),
                ),
              ),
            ),
          ),

          // Filter Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: ProductFilterSection(
                selectedSort: controller.selectedSort,
                onlyAvailable: controller.onlyAvailable,
                categories: controller.categories,
                selectedCategoryId: controller.selectedCategoryId,
              ),
            ),
          ),

          // Product List
          Obx(() {
            if (controller.isLoading.value && controller.products.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4A90E2),
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            if (controller.products.isEmpty) {
              return const SliverFillRemaining(child: ProductEmptyState());
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = controller.products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProductCard(
                      product: product,
                      onTap: () =>
                          Get.to(() => ProductFormView(product: product)),
                      onDelete: () => controller.deleteProduct(product.id),
                    ),
                  );
                }, childCount: controller.products.length),
              ),
            );
          }),
        ],
      ),

      // Modern FAB with Shadow
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const ProductFormView()),
          backgroundColor: const Color(0xFF4A90E2),
          elevation: 0,
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            'Add Product',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
