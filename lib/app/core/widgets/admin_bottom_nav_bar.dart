import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/admin/admin_dashboard/controllers/admin_dashboard_controller.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: controller.bottomNavIndex.value == 0,
                  onTap: () => controller.selectBottomNav(0),
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_rounded,
                  label: 'Orders',
                  isActive: controller.bottomNavIndex.value == 1,
                  onTap: () => controller.selectBottomNav(1),
                ),
                _buildNavItem(
                  icon: Icons.inventory_2_rounded,
                  label: 'Products',
                  isActive: controller.bottomNavIndex.value == 2,
                  onTap: () => controller.selectBottomNav(2),
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: controller.bottomNavIndex.value == 3,
                  onTap: () => controller.selectBottomNav(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? Colors.blue.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.blue.shade600 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
