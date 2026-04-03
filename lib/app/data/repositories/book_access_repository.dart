import 'dart:io';
import '../providers/book_access_provider.dart';
import '../models/reading_stat_model.dart';

class BookAccessRepository {
  final BookAccessProvider provider;

  BookAccessRepository(this.provider);

  Future<File?> getPdfForRead(int productId, String fileName) {
    return provider.getPdfForRead(productId, fileName);
  }

  Future<bool> downloadPdfToDevice(int productId, String fileName) {
    return provider.downloadPdfToDevice(productId, fileName);
  }

  Future<List<ReadingStatModel>> getReadingStats() {
    return provider.getReadingStats();
  }
}