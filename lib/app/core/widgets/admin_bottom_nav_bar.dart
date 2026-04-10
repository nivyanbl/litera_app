import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final currentRoute = Get.currentRoute;
    if (currentRoute.contains('admin-orders')) {
      _selectedIndex = 1;
    } else if (currentRoute.contains('admin-produk')) {
      _selectedIndex = 2;
    } else {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                isActive: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  Get.offNamed('/admin-dashboard');
                },
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'Orders',
                isActive: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  Get.offNamed('/admin-orders');
                },
              ),
              _buildNavItem(
                icon: Icons.inventory_2_rounded,
                label: 'Produk',
                isActive: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  Get.offNamed('/admin-produk');
                },
              ),
            ],
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
