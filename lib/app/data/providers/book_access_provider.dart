import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/network/api_client.dart';
import '../models/reading_stat_model.dart';

class BookAccessProvider {
  final ApiClient apiClient;

  BookAccessProvider(this.apiClient);

  // Fungsi READ 
  Future<File?> getPdfForRead(int productId, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      await apiClient.download('/books/$productId/read', file.path);
      return file;
    } catch (e) {
      Get.log("Error read PDF: $e");
      return null;
    }
  }

  // Fungsi DOWNLOAD 
  Future<bool> downloadPdfToDevice(int productId, String fileName) async {
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      
      final file = File('${dir!.path}/$fileName');

      await apiClient.download(
        '/books/$productId/download',
        file.path,
      );
      return true;
    } catch (e) {
      Get.log("Error download PDF: $e");
      return false;
    }
  }

  //  Fungsi GET STATS (Mengambil riwayat membaca)
  Future<List<ReadingStatModel>> getReadingStats() async {
    try {
      final response = await apiClient.get('/books/reading-stats');
      
      if (response.data == null) return [];
      final data = response.data['data'] ?? response.data;

      if (data is! List) return [];
      return data.map((e) => ReadingStatModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      Get.log("Error get stats: $e");
      return [];
    }
  }
}