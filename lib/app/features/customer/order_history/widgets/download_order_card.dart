import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/services/download_service.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/data/repositories/book_access_repository.dart';
import 'package:litera/app/features/customer/order_history/widgets/order_thumbnail.dart';
import 'package:litera/app/routes/app_pages.dart';

class DownloadOrderCard extends StatefulWidget {
  const DownloadOrderCard({
    super.key,
    required this.order,
    required this.detail,
  });

  final OrderModel order;
  final OrderDetailModel detail;

  @override
  State<DownloadOrderCard> createState() => _DownloadOrderCardState();
}

class _DownloadOrderCardState extends State<DownloadOrderCard> {
  late final DownloadService downloadService;
  late final BookAccessRepository bookAccessRepository;
  var isDownloading = false.obs;

  @override
  void initState() {
    super.initState();
    downloadService = DownloadService.to;
    bookAccessRepository = Get.find<BookAccessRepository>();
  }

  @override
  Widget build(BuildContext context) {
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
            imageUrl: widget.detail.product?.image,
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
                  widget.detail.product?.title ?? 'Buku',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.grayDarker,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.detail.product?.author ?? 'Buku digital',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grayNormal,
                  ),
                ),
              ],
            ),
          ),
          // Reactive button berdasarkan status unduhan
          Obx(() {
            final detailId = (widget.detail.id ?? 0).toString();
            final isDownloaded = downloadService.isDownloaded(detailId);
            return isDownloaded
                ? _buildReadButton()
                : _buildDownloadButton(detailId);
          }),
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
        // Navigate ke BookAccessView
        Get.toNamed(
          Routes.bookAccess,
          arguments: {
            'product_id': widget.detail.productId,
            'title': widget.detail.product?.title ?? 'Buku',
          },
        );
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

  Widget _buildDownloadButton(String detailId) {
    return Obx(
      () => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNormal,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(74, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isDownloading.value ? null : () => _handleDownload(detailId),
        icon: isDownloading.value
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.download_rounded, size: 16),
        label: Text(
          isDownloading.value ? 'Menunduh...' : 'Unduh',
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _handleDownload(String detailId) async {
    // Cek apakah product ada
    if (widget.detail.productId == null) {
      Get.snackbar('Error', 'Product ID tidak ditemukan');
      return;
    }

    isDownloading.value = true;
    try {
      final safeFileName =
          '${widget.detail.product?.title?.replaceAll(' ', '_') ?? 'book'}.pdf';

      bool success = await bookAccessRepository.downloadPdfToDevice(
        widget.detail.productId!,
        safeFileName,
      );

      if (success) {
        // Mark sebagai downloaded di DownloadService
        await downloadService.markAsDownloaded(detailId);

        Get.snackbar(
          'Berhasil',
          'E-book berhasil diunduh',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal mengunduh e-book',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDownloading.value = false;
    }
  }
}
