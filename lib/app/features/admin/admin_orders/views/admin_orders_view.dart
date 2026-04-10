import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:litera/app/features/admin/admin_orders/controllers/admin_orders_controller.dart';
import 'package:litera/app/features/admin/admin_orders/widgets/order_card_widget.dart';
import 'package:litera/app/features/admin/admin_orders/widgets/order_card_skeleton.dart';
import 'package:litera/app/features/admin/admin_orders/widgets/order_empty_state.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Pesanan',
          style: AppTextStyles.headlineMedium.copyWith(
            fontFamily: 'Poppins',
            color: AppColors.grayDarker,
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          final controller = Get.find<AdminOrdersController>();

          return RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: controller.refreshOrders,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── Progress text ───────────────────────────────────────────
                if (controller.hasOrders)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        controller.progressText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayNormal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                // ── Error State ──────────────────────────────────────────────
                if (controller.hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Loading State ────────────────────────────────────────────
                if (controller.isLoading.value)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => OrderCardSkeleton(index: index),
                        childCount: 5,
                      ),
                    ),
                  )
                // ── Empty State ──────────────────────────────────────────────
                else if (controller.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const OrderEmptyStateWidget(),
                  )
                // ── Order List ──────────────────────────────────────────────
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = controller.orders[index];
                          return OrderCardWidget(
                            key: ValueKey(order.id),
                            order: order,
                            formatCurrency: controller.formatCurrency,
                          );
                        },
                        childCount: controller.orders.length,
                      ),
                    ),
                  ),

                // ── Pagination Controls ────────────────────────────────────────
                if (controller.hasOrders && controller.lastPage.value > 1)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: _buildPaginationSection(controller),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }

  Widget _buildPaginationSection(AdminOrdersController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Prev - Next Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Prev Button
            if (controller.canPrevious)
              GestureDetector(
                onTap: controller.prevPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryNormal,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '< Sebelumnya',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNormal,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '< Sebelumnya',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grayNormal,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            const SizedBox(width: 16),
            // Next Button
            if (controller.canNext)
              GestureDetector(
                onTap: controller.nextPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryNormal,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Selanjutnya >',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNormal,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selanjutnya >',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grayNormal,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Page Numbers
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: controller.pageNumbers
              .map((page) {
                final isCurrentPage = page == controller.currentPage.value;
                return GestureDetector(
                  onTap: () => controller.goToPage(page),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCurrentPage
                          ? AppColors.primaryNormal
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isCurrentPage
                            ? AppColors.primaryNormal
                            : AppColors.grayLight,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isCurrentPage
                              ? Colors.white
                              : AppColors.grayDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList(),
        ),
      ],
    );
  }
}
