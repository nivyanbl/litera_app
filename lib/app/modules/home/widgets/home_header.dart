import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: AppTextStyles.labelLarge,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          const SizedBox(width: 10),
          const Icon(Icons.favorite_outline, color: Colors.black87),
        ],
      ),
    );
  }
}
