import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/shimmer_loading.dart';
import 'package:litera/app/features/customer/book_access/controllers/book_access_controller.dart';

class BookAccessView extends GetView<BookAccessController> {
  const BookAccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title, style: AppTextStyles.bodyLarge),
        actions: [
          Obx(
            () => IconButton(
              icon: controller.isDownloading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.download),
              onPressed: controller.isDownloading.value
                  ? null
                  : () => controller.downloadToDevice(),
              tooltip: 'Simpan PDF ke Perangkat',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerProductDetail();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.pdfFile.value != null) {
          return PDFView(
            filePath: controller.pdfFile.value!.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              Get.log('Error PDF: $error');
            },
            onPageError: (page, error) {
              Get.log('Error Page $page: $error');
            },
          );
        }

        return const SizedBox();
      }),
    );
  }
}
