import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/widgets/app_icon.dart';
import 'package:litera/app/modules/product_detail/widgets/product_detail_widget.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final imageUrl = controller.imageUrl;
    final descriptionText = controller.descriptionText;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailImage(imageUrl: imageUrl),
                    const SizedBox(height: 34),
                    ProductDetailHeader(
                      product: product,
                      onLoveTap: controller.handleLoveTap,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => ProductDetailDescription(
                        descriptionText: descriptionText,
                        isExpanded: controller.isExpanded.value,
                        onToggle: controller.toggleExpanded,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ProductDetailInfoSection(product: product),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            ProductDetailBottomActions(
              onBuyNow: controller.handleBuyNow,
              onAddToCart: controller.handleAddToCart,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const AppIcon(icon: Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const AppIcon(icon: Icons.shopping_cart_outlined),
          onPressed: controller.handleCartIcon,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
