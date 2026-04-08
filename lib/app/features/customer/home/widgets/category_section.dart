import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/network/api_client.dart';
import '../../../../data/providers/category_provider.dart';
import '../../../../data/repositories/category_repository.dart';
import '../controllers/category_controller.dart';

class CategorySection extends StatelessWidget {
  CategorySection({super.key});

  final CategoryController controller = Get.put(
    CategoryController(
      CategoryRepository(categoryProvider: CategoryProvider(Get.find<ApiClient>())),
    ),
  );

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

        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.categories.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Belum ada kategori buku"),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: controller.categories.map((kategori) {
                return Obx(() {
                  bool isActive =
                      controller.selectedCategoryId.value == kategori.id;

                  return GestureDetector(
                    onTap: () => controller.selectCategory(kategori.id),
                    child: _categoryChip(kategori.name, isActive: isActive),
                  );
                });
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

Widget _categoryChip(String label, {bool isActive = false}) {
  return Container(
    width: 100,
    height: 40,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: ShapeDecoration(
      color: isActive ? AppColors.primaryNormal.withValues(alpha: 0.1) : Colors.white, 
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isActive ? AppColors.primaryNormal : const Color(0xFFC8C8CC), 
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primaryNormal : Colors.black,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          height: 1.0,
        ),
      ),
    ),
  );
}}
