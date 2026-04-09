import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EditProfileFieldTile extends StatelessWidget {
  const EditProfileFieldTile({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grayLight),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: AppColors.grayDark),
          labelText: label,
          labelStyle: AppTextStyles.labelSmall,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          filled: readOnly,
          fillColor: readOnly ? AppColors.grayLight.withValues(alpha: 0.3) : null,
        ),
      ),
    );
  }
}