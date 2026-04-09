import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text(value, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.grayLight),
      ],
    );
  }
}
