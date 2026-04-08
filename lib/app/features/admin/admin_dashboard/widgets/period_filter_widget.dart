import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import '../controllers/admin_dashboard_controller.dart';

class PeriodFilterWidget extends StatelessWidget {
  const PeriodFilterWidget({super.key});

  static const _periods = [
    {'label': '7 Hari', 'days': 7},
    {'label': '30 Hari', 'days': 30},
    {'label': '90 Hari', 'days': 90},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Obx(() {
      final selected = controller.selectedDays.value;
      return Row(
        children: _periods.map((period) {
          final days = period['days'] as int;
          final isActive = selected == days;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _FilterChip(
              label: period['label'] as String,
              isActive: isActive,
              onTap: () => controller.onPeriodChanged(days),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryNormal : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryNormal.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.grayDarker,
          ),
        ),
      ),
    );
  }
}
