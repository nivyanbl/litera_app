import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/data/models/category_model.dart';

class ProductFilterSection extends StatelessWidget {
  final RxString selectedSort;
  final RxBool onlyAvailable;
  final RxList<CategoryModel> categories;
  final RxnInt selectedCategoryId;

  const ProductFilterSection({
    Key? key,
    required this.selectedSort,
    required this.onlyAvailable,
    required this.categories,
    required this.selectedCategoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top row: Sort and In Stock filter
        Row(
          children: [
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedSort.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'newest', child: Text('Newest')),
                    DropdownMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'stock_low',
                      child: Text('Stock: Low to High'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) selectedSort.value = val;
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Obx(
              () => Row(
                children: [
                  const Text(
                    'In Stock',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: onlyAvailable.value,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) => onlyAvailable.value = val,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
