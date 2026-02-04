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
              _categoryChip("Buku"),
              _categoryChip("Koran"),
              _categoryChip("Majalah"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryChip(String label, {bool isActive = false}) {
    return Container(
      width: 125, 
      height: 40, 
      margin: const EdgeInsets.only(right: 12), 
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: isActive ? Colors.blue : Colors.transparent, 
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isActive ? Colors.blue : const Color(0xFFC8C8CC), 
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Center( 
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 14, 
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.w500, 
            height: 1.0,
          ),
        ),
      ),
    );
  }
}