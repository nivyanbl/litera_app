import 'package:intl/intl.dart';

class DateFormatter {
  /// Format tanggal ke format Indonesia (contoh: "18 Agu 2023")
  static String formatToIndonesian(String? date) {
    if (date == null || date.isEmpty) return '-';
    
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy', 'id_ID').format(parsed);
    } catch (e) {
      // Jika gagal parse, return as is
      return date;
    }
  }

  static String formatToIndonesianLong(String? date) {
    if (date == null || date.isEmpty) return '-';
    
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formatToIndonesianWithTime(String? date) {
    if (date == null || date.isEmpty) return '-';
    
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formatToReadableIndonesian(String? date) {
    if (date == null || date.isEmpty) return '-';
    
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsed);
    } catch (e) {
      return date;
    }
  }
}
