import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/widgets/admin_bottom_nav_bar.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/period_filter_widget.dart';
import '../widgets/revenue_card_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/product_card_widget.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue.shade600,
              ),
            ),
          ),
        );
      }

      final data = controller.dashboardData.value;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.fetchDashboardData,
            color: Colors.blue.shade600,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                const SliverToBoxAdapter(
                  child: DashboardHeaderWidget(),
                ),
                // Period Filter Chips
                const SliverToBoxAdapter(
                  child: PeriodFilterWidget(),
                ),
                // Total Revenue Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: RevenueCardWidget(
                      totalRevenue: data.totalRevenue,
                    ),
                  ),
                ),
                // Chart Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: const ChartWidget(),
                  ),
                ),
                // Best Sellers Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Text(
                      'Produk Terlaris 🔥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                ),
                // Best Sellers List
                if (data.bestSellers == null || data.bestSellers!.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'Belum ada data penjualan.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: data.bestSellers!.length,
                      itemBuilder: (context, index) {
                        final item = data.bestSellers![index];
                        final product = item['product'] ?? {};
                        final totalSold = int.tryParse(
                          item['total_sold']?.toString() ?? '0',
                        ) ??
                            0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductCardWidget(
                            productTitle:
                                product['title'] ?? 'Buku Tidak Diketahui',
                            totalSold: totalSold,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                // Bottom spacing
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AdminBottomNavBar(),
      );
    });
  }
}
