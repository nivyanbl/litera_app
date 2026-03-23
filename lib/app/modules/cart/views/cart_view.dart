import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/custom_app_bar.dart';
import 'package:litera/app/core/widgets/custom_button.dart';
import 'package:litera/app/modules/cart/controllers/cart_controller.dart';
import 'package:litera/app/routes/app_pages.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  static final _fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: const CustomAppBar(title: 'Keranjang', showRightIcon: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return controller.cartList.isEmpty
            ? _buildEmptyState()
            : _buildCartList();
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  //  Cart List
  Widget _buildCartList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: controller.cartList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) => _buildCartItem(index),
    );
  }

  //  Cart Item
  Widget _buildCartItem(int index) {
    final item = controller.cartList[index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox
          _buildCheckbox(index),
          const SizedBox(width: 10),

          // Cover buku
          _buildBookCover(item.product?.image),
          const SizedBox(width: 12),

          // Info + hapus
          Expanded(child: _buildItemInfo(index)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(int index) {
    final isSelected = index == -1
        ? controller.cartList.isNotEmpty &&
              controller.cartList.every((e) => e.isSelected)
        : controller.cartList[index].isSelected;

    return GestureDetector(
      onTap: () {
        if (index == -1) {
          controller.toggleSelectAll();
        } else {
          controller.toggleSelect(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNormal : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryNormal : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 13, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildBookCover(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 76,
              height: 106,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _coverPlaceholder(),
            )
          : _coverPlaceholder(),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      width: 76,
      height: 106,
      color: Colors.grey.shade200,
      child: Icon(Icons.book_outlined, size: 28, color: Colors.grey.shade400),
    );
  }

  Widget _buildItemInfo(int index) {
    final item = controller.cartList[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge kategori
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.product?.category?.name ?? 'Tanpa Kategori',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Judul
        Text(
          item.product?.author.isNotEmpty == true
              ? item.product!.author
              : 'Penulis tidak diketahui',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grayNormal),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Judul
        Text(
          item.product?.title ?? 'Tanpa Judul',
          style: AppTextStyles.titleSmall.copyWith(color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Harga
        Text(
          _fmt.format(item.product?.price ?? 0),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Tombol hapus
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () => controller.removeItem(item.id!),
            child: Container(
              width: 70,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: Colors.grey, width: 0.8),
              ),
              child: Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/cart.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Keranjang masih kosong',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk temukan buku yang kamu suka!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Mulai Belanja',
            isLoading: false,
            onPressed: () => Get.toNamed(Routes.HOME),
          ),
        ],
      ),
    );
  }

  //  Bottom Bar
  Widget _buildBottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Info banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_rounded,
                size: 20,
                color: AppColors.primaryNormal,
              ),
              const SizedBox(width: 12),
              Text(
                'eBook hanya bisa dibeli 1x per judul.',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.grayNormal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),

        // Bar utama
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Obx(
              () => Row(
                children: [
                  // Checkbox semua
                  _buildCheckbox(-1),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.toggleSelectAll,
                    child: Text(
                      'Semua',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.grayNormal,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Subtotal
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Subtotal',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _fmt.format(controller.totalPrice),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Tombol beli
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedCount > 0
                          ? AppColors.primaryNormal
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.selectedCount > 0
                        ? () {
                            Get.toNamed(Routes.CHECKOUT);
                          }
                        : null,
                    child: Text(
                      controller.selectedCount > 0
                          ? 'Beli (${controller.selectedCount})'
                          : 'Beli',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
