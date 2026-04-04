import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/app_icon.dart';
import 'package:litera/app/core/widgets/shimmer_loading.dart';
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
            Obx(() {
              // Jika masih mengecek API, tampilkan indikator loading
              if (controller.isLoadingOwnership.value) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child:  SkeletonCheckoutItem(),
                );
              }

              // Jika BUKU SUDAH DIMILIKI (is_owned == true)
              if (controller.isOwned.value) {
                // Jika sudah diunduh
                if (controller.isDownloaded.value) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Tombol Baca Sekarang (outline)
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: controller.goToReadBook,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryNormal,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Baca Sekarang',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol Hapus (merah)
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _showDeleteConfirmation(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorNormal,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // Jika belum diunduh
                else {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isDownloading.value
                              ? null
                              : controller.handleDownloadEbook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNormal,
                            disabledBackgroundColor: Colors.grey.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.isDownloading.value) ...[
                                const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Text(
                                controller.isDownloading.value
                                    ? 'Mengunduh...'
                                    : 'Unduh Buku',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
              // Jika BUKU BELUM DIMILIKI (is_owned == false)
              else {
                return ProductDetailBottomActions(
                  onBuyNow: controller.handleBuyNow,
                  onAddToCart: controller.handleAddToCart,
                );
              }
            }),
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

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Unduhan'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus unduhan e-book ini?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.handleDeleteDownload();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
