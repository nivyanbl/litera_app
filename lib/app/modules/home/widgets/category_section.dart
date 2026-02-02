import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategori Buku",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Lihat Semua",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grayDark,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _categoryChip("Novel"),
              _categoryChip("Komik"),
              _categoryChip("Pelajaran"),
              _categoryChip("Biografi"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.white,
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
