import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/data/models/category_model.dart';

class ProductFilterSection extends StatelessWidget {
  final RxString selectedSort;
  final RxBool onlyAvailable;
  final RxList<CategoryModel> categories;
  final RxnInt selectedCategoryId;

  const ProductFilterSection({
    super.key,
    required this.selectedSort,
    required this.onlyAvailable,
    required this.categories,
    required this.selectedCategoryId,
  });

  String _sortLabel(String value) {
    switch (value) {
      case 'newest':
        return 'Newest';
      case 'price_high':
        return 'Price: High to Low';
      case 'price_low':
        return 'Price: Low to High';
      case 'stock_low':
        return 'Stock: Low to High';
      default:
        return 'Newest';
    }
  }

  List<Map<String, String>> get _sortOptions => const [
    {'value': 'newest', 'label': 'Newest'},
    {'value': 'price_high', 'label': 'Price: High to Low'},
    {'value': 'price_low', 'label': 'Price: Low to High'},
    {'value': 'stock_low', 'label': 'Stock: Low to High'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort dropdown custom design
        Obx(
          () => _FilterDropdownCard(
            title: _sortLabel(selectedSort.value),
            onTap: () {
              _showSortBottomSheet(context);
            },
          ),
        ),

        const SizedBox(height: 14),

        // Category dropdown custom design
        Obx(() {
          final selectedCategory = categories.firstWhereOrNull(
            (e) => e.id == selectedCategoryId.value,
          );

          return _FilterDropdownCard(
            title: selectedCategory?.name ?? 'All Categories',
            onTap: () {
              _showCategoryBottomSheet(context);
            },
          );
        }),

        const SizedBox(height: 16),

        // In stock switch card
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grayLight, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'In Stock Only',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grayDarker,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: onlyAvailable.value,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primaryNormal,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.grayLight,
                    onChanged: (val) => onlyAvailable.value = val,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grayLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.grayLightActive,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sort By',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grayDarker,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ..._sortOptions.map((item) {
                final isSelected = selectedSort.value == item['value'];

                return GestureDetector(
                  onTap: () {
                    selectedSort.value = item['value']!;
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryNormal
                            : AppColors.grayLight,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['label']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryNormal
                                  : AppColors.grayDarker,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            color: AppColors.primaryNormal,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grayLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.grayLightActive,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grayDarker,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        final isSelected = selectedCategoryId.value == null;

                        return _CategoryTile(
                          title: 'All Categories',
                          isSelected: isSelected,
                          onTap: () {
                            selectedCategoryId.value = null;
                            Get.back();
                          },
                        );
                      }

                      final category = categories[index - 1];
                      final isSelected =
                          selectedCategoryId.value == category.id;

                      return _CategoryTile(
                        title: category.name,
                        isSelected: isSelected,
                        onTap: () {
                          selectedCategoryId.value = category.id;
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _FilterDropdownCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _FilterDropdownCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: AppColors.grayLight, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayDarker,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.grayNormal,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryLight : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryNormal : AppColors.grayLight,
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryNormal
                        : AppColors.grayDarker,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryNormal,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
