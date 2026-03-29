import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/custom_app_bar.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/modules/order_history/controllers/order_history_controller.dart';
import 'package:litera/app/modules/order_history/widgets/download_order_card.dart';
import 'package:litera/app/modules/order_history/widgets/history_order_card.dart';
import 'package:litera/app/modules/order_history/views/order_payment_detail_view.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Buku Saya',
          rightIcon: Icons.search,
          onRightIconPressed: () {},
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.grayDark,
                    labelStyle: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: AppTextStyles.titleSmall,
                    tabs: const [
                      Tab(text: "Unduhan"),
                      Tab(text: "Riwayat"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildDownloadList(controller.completedOrders),
                    _buildHistoryList(controller.allOrders),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDownloadList(List<OrderModel> orders) {
    final downloadItems = orders
        .expand(
          (order) => (order.details ?? const <OrderDetailModel>[]).map(
            (detail) => _DownloadItem(order: order, detail: detail),
          ),
        )
        .toList();

    if (downloadItems.isEmpty) {
      return _buildEmptyState('Belum ada buku yang bisa diunduh.');
    }

    return RefreshIndicator(
      onRefresh: controller.fetchOrders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: downloadItems.length,
        itemBuilder: (context, index) {
          final item = downloadItems[index];
          return DownloadOrderCard(
            key: ValueKey(
              'download-${item.order.externalId ?? item.order.id ?? 'order'}-'
              '${item.detail.id ?? index}',
            ),
            order: item.order,
            detail: item.detail,
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState('Belum ada riwayat pembayaran.');
    }

    return RefreshIndicator(
      onRefresh: controller.fetchOrders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return HistoryOrderCard(
            key: ValueKey('history-${order.externalId ?? order.id ?? index}'),
            order: order,
            onTap: () {
              Get.to(
                () => OrderPaymentDetailView(order: order),
              )?.then((_) => controller.fetchOrders());
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grayNormal),
      ),
    );
  }
}

class _DownloadItem {
  const _DownloadItem({required this.order, required this.detail});

  final OrderModel order;
  final OrderDetailModel detail;
}
