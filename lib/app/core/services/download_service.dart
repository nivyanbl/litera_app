import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DownloadService extends GetxService {
  final storage = GetStorage();

  // Map untuk menyimpan status unduhan: bookId -> isDownloaded
  final RxMap<String, bool> downloadedBooks = <String, bool>{}.obs;

  static DownloadService get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    _loadDownloadedBooks();
  }

  /// Load semua buku yang sudah diunduh dari storage
  void _loadDownloadedBooks() {
    try {
      final savedBooks = storage.read('downloaded_books');

      if (savedBooks != null && savedBooks is Map) {
        final Map<String, bool> books = {};
        savedBooks.forEach((key, value) {
          books[key.toString()] = value as bool;
        });
        downloadedBooks.addAll(books);
      }
      // Jika data tidak valid atau tidak ada, mulai dengan map kosong
    } catch (e) {
      Get.log('Error loading downloaded books: $e');
      downloadedBooks.clear();
    }
  }

  /// Cek apakah buku sudah diunduh
  bool isDownloaded(String bookId) {
    return downloadedBooks[bookId] ?? false;
  }

  /// Mark buku sebagai diunduh
  Future<void> markAsDownloaded(String bookId) async {
    downloadedBooks[bookId] = true;
    // Convert RxMap ke Map biasa sebelum disave
    await storage.write('downloaded_books', Map.from(downloadedBooks));
  }

  /// Hapus status unduhan buku
  Future<void> removeDownload(String bookId) async {
    downloadedBooks.remove(bookId);
    // Convert RxMap ke Map biasa sebelum disave
    await storage.write('downloaded_books', Map.from(downloadedBooks));
  }

  /// Get reactive status unduhan untuk satu buku
  RxBool getDownloadStatus(String bookId) {
    return RxBool(isDownloaded(bookId))..listen((value) {
      // Update otomatis ketika status berubah
    });
  }

  /// Get list buku yang sudah diunduh
  List<String> getDownloadedBooksList() {
    return downloadedBooks.entries
        .where((e) => e.value == true)
        .map((e) => e.key)
        .toList();
  }

  /// Clear semua unduhan
  Future<void> clearAllDownloads() async {
    downloadedBooks.clear();
    await storage.write('downloaded_books', {});
  }
}
