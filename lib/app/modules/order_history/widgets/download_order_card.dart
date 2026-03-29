import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/modules/order_history/widgets/order_thumbnail.dart';

class DownloadOrderCard extends StatelessWidget {
  const DownloadOrderCard({
    super.key,
    required this.order,
    required this.detail,
  });

  final OrderModel order;
  final OrderDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final canRead = order.canReadBook;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayLightActive),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          OrderThumbnail(
            imageUrl: detail.product?.image,
            width: 64,
            height: 86,
            borderRadius: 8,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.product?.title ?? 'Buku',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.grayDarker,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  detail.product?.author ?? 'Buku digital',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grayNormal,
                  ),
                ),
              ],
            ),
          ),
          canRead ? _buildReadButton() : _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildReadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNormal,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(74, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Get.snackbar('Info', 'Fitur baca/unduh akan segera tersedia');
      },
      child: Text(
        'Baca',
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNormal,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(74, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Get.snackbar('Info', 'Fitur baca/unduh akan segera tersedia');
      },
      icon: const Icon(Icons.download_rounded, size: 16),
      label: Text(
        'Unduh',
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
