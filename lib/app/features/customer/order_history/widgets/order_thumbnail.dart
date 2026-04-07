import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';

class OrderThumbnail extends StatelessWidget {
  const OrderThumbnail({
    super.key,
    this.imageUrl,
    this.width = 54,
    this.height = 72,
    this.borderRadius = 6,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: AppColors.grayLight,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported,
          size: 20,
          color: AppColors.grayNormal,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.grayLight,
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_not_supported,
              size: 20,
              color: AppColors.grayNormal,
            ),
          );
        },
      ),
    );
  }
}
