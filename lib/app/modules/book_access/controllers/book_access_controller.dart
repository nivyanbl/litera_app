import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/data/repositories/book_access_repository.dart';

class BookAccessController extends GetxController {
  final BookAccessRepository repository;
  BookAccessController(this.repository);

  var isLoading = false.obs;
  var isDownloading = false.obs;
  var pdfFile = Rxn<File>();
  var errorMessage = ''.obs;

  late int productId;
  late String title;
  late String safeFileName;

  @override
  void onInit() {
    super.onInit();

    productId = Get.arguments['product_id'];
    title = Get.arguments['title'];

    safeFileName = '${title.replaceAll(' ', '_')}.pdf';
    
    _loadPdfForRead();
  }  
  Future<void> _loadPdfForRead() async {
    isLoading.value = true;
    errorMessage.value = '';

    final file = await repository.getPdfForRead(productId, safeFileName);
    if (file != null) {
      pdfFile.value = file;
    } else {
      errorMessage.value = 'Gagal memuat PDF. Pastikan Anda sudah membeli buku ini.';
    }
    isLoading.value = false;
  }

  Future<void> downloadToDevice() async {
    isDownloading.value = true;
    try {
      bool success = await repository.downloadPdfToDevice(productId, safeFileName);
      if (success) {
        Get.snackbar("Berhasil", "Buku berhasil diunduh ke perangkat Anda.",
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
        
      } else {
        Get.snackbar("Gagal", "Terjadi kesalahan saat mengunduh buku.",
        backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      }
    } finally {
      isDownloading.value = false;
    }
  }
  

  
}
