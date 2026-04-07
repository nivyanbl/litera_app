import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class PeriodFilterWidget extends StatelessWidget {
  const PeriodFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              controller.periods.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  right: index == controller.periods.length - 1 ? 0 : 12,
                ),
                child: GestureDetector(
                  onTap: () => controller.selectPeriod(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: controller.selectedPeriodIndex.value == index
                          ? Colors.blue.shade600
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                      boxShadow: controller.selectedPeriodIndex.value == index
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      controller.periods[index],
                      style: TextStyle(
                        color: controller.selectedPeriodIndex.value == index
                            ? Colors.white
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
