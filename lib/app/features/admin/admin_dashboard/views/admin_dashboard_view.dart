import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:litera/app/features/admin/admin_dashboard/widgets/dashboard_header_widget.dart';
import 'package:litera/app/features/admin/admin_dashboard/widgets/product_card_widget.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/period_filter_widget.dart';
import '../widgets/revenue_card_widget.dart';
import '../widgets/section_title_widget.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is injected via AdminDashboardBinding
    return Scaffold(
      backgroundColor: AppColors.grayLight,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () =>
              Get.find<AdminDashboardController>().fetchDashboardData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── App bar space ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: const DashboardHeader(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // ── Error message ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  if (Get.find<AdminDashboardController>()
                      .errorMessage
                      .value
                      .isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        Get.find<AdminDashboardController>().errorMessage.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              // ── Period filter ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const PeriodFilterWidget(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Revenue card ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const RevenueCardWidget(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // ── Best Sellers ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionTitleWidget(
                    title: 'Best Seller',
                    subtitle: 'Produk paling banyak terjual',
                    trailing: _SeeAllButton(),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              _BestSellerList(),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // ── Most Carted ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionTitleWidget(
                    title: 'Paling Banyak Dilirik',
                    subtitle: 'Sering ditambah ke keranjang',
                    trailing: _SeeAllButton(),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              _MostCartedList(),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }
}

// ─── Error Banner ─────────────────────────────────────────────────────────────

// ─── Best Seller List ─────────────────────────────────────────────────────────

class _BestSellerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return _ProductListSkeleton();
      }
      final list = controller.dashboardData.value?.bestSellers ?? [];
      if (list.isEmpty) {
        return _EmptySection(message: 'Belum ada data best seller');
      }
      // Limit to 5 items, +1 for "See More" button if more available
      final displayCount = list.length > 5 ? 6 : list.length;
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // Show "See More" button on last item if list > 5
            if (index == 5 && list.length > 5) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  child: InkWell(
                    onTap: () => Get.toNamed('/admin/best-sellers'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryNormal,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Lihat semua (${list.length})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNormal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            final item = list[index];
            return ProductCardWidget(
              rank: index + 1,
              title: item.product.title,
              imageUrl: item.product.image,
              count: item.totalSold,
              variant: ProductCardVariant.bestSeller,
            );
          }, childCount: displayCount),
        ),
      );
    });
  }
}

// ─── Most Carted List ─────────────────────────────────────────────────────────

class _MostCartedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return _ProductListSkeleton();
      }
      final list = controller.dashboardData.value?.mostCarted ?? [];
      if (list.isEmpty) {
        return _EmptySection(message: 'Belum ada data keranjang');
      }
      // Limit to 5 items, +1 for "See More" button if more available
      final displayCount = list.length > 5 ? 6 : list.length;
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // Show "See More" button on last item if list > 5
            if (index == 5 && list.length > 5) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  child: InkWell(
                    onTap: () => Get.toNamed('/admin/most-carted'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryNormal,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Lihat semua (${list.length})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNormal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            final item = list[index];
            return ProductCardWidget(
              rank: index + 1,
              title: item.product.title,
              imageUrl: item.product.image,
              count: item.totalInCart,
              variant: ProductCardVariant.mostCarted,
            );
          }, childCount: displayCount),
        ),
      );
    });
  }
}

// ─── Misc helpers ─────────────────────────────────────────────────────────────

class _SeeAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Lihat semua',
      style: TextStyle(
        fontSize: 12,
        color: AppColors.primaryNormal,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: Text(
            message,
            style: TextStyle(fontSize: 13, color: AppColors.primaryDark),
          ),
        ),
      ),
    );
  }
}

class _ProductListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, _) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                const SizedBox(width: 14),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
              ],
            ),
          ),
          childCount: 3,
        ),
      ),
    );
  }
}
