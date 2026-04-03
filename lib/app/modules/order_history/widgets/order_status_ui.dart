import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';

class OrderStatusUi {
  OrderStatusUi._(this.key);

  final String key;

  factory OrderStatusUi.from(String? status) {
    final normalized = (status ?? '').toLowerCase();

    if (normalized == 'paid') {
      return OrderStatusUi._('paid');
    }

    if (normalized == 'pending') {
      return OrderStatusUi._('pending');
    }

    if (normalized == 'expired' ||
        normalized == 'cancelled' ||
        normalized == 'failed') {
      return OrderStatusUi._('failed');
    }

    return OrderStatusUi._('unknown');
  }

  bool get isPaid => key == 'paid';

  Color get color {
    switch (key) {
      case 'paid':
        return AppColors.successNormal;
      case 'pending':
        return AppColors.warningNormal;
      case 'failed':
        return AppColors.errorNormal;
      default:
        return AppColors.grayNormal;
    }
  }

  String get historyLabel {
    switch (key) {
      case 'paid':
        return 'Transaksi Sukses';
      case 'pending':
        return 'Transaksi Pending';
      case 'failed':
        return 'Transaksi Gagal';
      default:
        return 'Status Tidak Diketahui';
    }
  }

  String get detailTitle {
    switch (key) {
      case 'paid':
        return 'Transaksi Sukses';
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'failed':
        return 'Transaksi Gagal';
      default:
        return 'Status Tidak Diketahui';
    }
  }
}
