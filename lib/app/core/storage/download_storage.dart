import 'package:get_storage/get_storage.dart';

class DownloadStorage {
  static const _downloadsKey = 'downloaded_books';
  static final _box = GetStorage();

  /// Check if a book is downloaded locally
  static bool isBookDownloaded(int productId) {
    final downloads = _getDownloads();
    return downloads.contains(productId);
  }

  /// Mark a book as downloaded
  static Future<void> markAsDownloaded(int productId) async {
    final downloads = _getDownloads();
    if (!downloads.contains(productId)) {
      downloads.add(productId);
      await _box.write(_downloadsKey, downloads);
    }
  }

  /// Remove a downloaded book record
  static Future<void> removeDownload(int productId) async {
    final downloads = _getDownloads();
    downloads.removeWhere((id) => id == productId);
    await _box.write(_downloadsKey, downloads);
  }

  /// Get all downloaded book IDs
  static List<int> getDownloadedBooks() {
    return _getDownloads();
  }

  /// Clear all download records
  static Future<void> clearAllDownloads() async {
    await _box.erase();
  }

  static List<int> _getDownloads() {
    final data = _box.read(_downloadsKey);
    if (data == null) return [];

    if (data is List) {
      return data.map((e) => e as int).toList();
    }

    return [];
  }
}
