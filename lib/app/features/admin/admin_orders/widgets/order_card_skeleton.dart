import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';

class OrderCardSkeleton extends StatelessWidget {
  final int index;

  const OrderCardSkeleton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grayLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonLine(width: 60, height: 10),
                      const SizedBox(height: 8),
                      _SkeletonLine(width: 120, height: 14),
                    ],
                  ),
                ),
                _SkeletonLine(width: 60, height: 24),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.grayLight, height: 1),
            const SizedBox(height: 16),
            // User info skeleton
            _SkeletonLine(width: 50, height: 10),
            const SizedBox(height: 8),
            _SkeletonLine(width: 150, height: 14),
            const SizedBox(height: 6),
            _SkeletonLine(width: 180, height: 12),
            const SizedBox(height: 12),
            Divider(color: AppColors.grayLight, height: 1),
            const SizedBox(height: 12),
            // Price skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonLine(width: 40, height: 12),
                _SkeletonLine(width: 80, height: 14),
              ],
            ),
            const SizedBox(height: 12),
            // Payment method skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonLine(width: 100, height: 12),
                _SkeletonLine(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonLine({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
