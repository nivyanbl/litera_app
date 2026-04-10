import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/widgets/custom_app_bar.dart';
import 'package:litera/app/core/widgets/admin_bottom_nav_bar.dart';
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Products',
        showLeftIcon: false,
        showRightIcon: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
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
                      if (controller.isLoading.value &&
                          controller.products.isEmpty) {
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
                        return const SliverFillRemaining(
                          child: ProductEmptyState(),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final product = controller.products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ProductCard(
                                product: product,
                                onTap: () {},
                                onEdit: () =>
                                    Get.to(() => ProductFormView(product: product)),
                                onDelete: () =>
                                    controller.deleteProduct(product.id),
                              ),
                            );
                          }, childCount: controller.products.length),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          // Floating Add Product Button
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryNormal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(() => const ProductFormView()),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Add Product',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }
}
