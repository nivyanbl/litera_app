import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String status;

  const StatusBadgeWidget({
    super.key,
    required this.status,
  });

  Color _getBackgroundColor(String status) {
    final normalizedStatus = status.toLowerCase();
    if (normalizedStatus == 'paid') {
      return AppColors.successLight;
    } else if (normalizedStatus == 'expired' || normalizedStatus == 'failed') {
      return AppColors.errorLight;
    } else if (normalizedStatus == 'pending') {
      return AppColors.warningLight;
    }
    return AppColors.grayLight;
  }

  Color _getTextColor(String status) {
    final normalizedStatus = status.toLowerCase();
    if (normalizedStatus == 'paid') {
      return AppColors.successNormal;
    } else if (normalizedStatus == 'expired' || normalizedStatus == 'failed') {
      return AppColors.errorNormal;
    } else if (normalizedStatus == 'pending') {
      return AppColors.warningNormal;
    }
    return AppColors.grayNormal;
  }

  String _getDisplayLabel(String status) {
    final normalizedStatus = status.toLowerCase();
    final Map<String, String> labels = {
      'pending': 'Menunggu',
      'paid': 'Dibayar',
      'expired': 'Expired',
      'failed': 'Gagal',
      'cancelled': 'Dibatalkan',
    };
    return labels[normalizedStatus] ?? status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getDisplayLabel(status),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getTextColor(status),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
