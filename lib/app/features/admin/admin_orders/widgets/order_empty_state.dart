import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';

class OrderEmptyStateWidget extends StatelessWidget {
  const OrderEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.primaryNormal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Pesanan',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: 'Poppins',
                color: AppColors.grayDarker,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan dari pelanggan akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grayNormal,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
