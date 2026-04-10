import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'status_badge_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final String Function(String?) formatCurrency;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.formatCurrency,
  });

  String _buildProductsString() {
    final details = order.details ?? [];
    if (details.isEmpty) return '-';

    if (details.length == 1) {
      final product = details.first.product;
      return product?.title ?? 'Produk Tidak Diketahui';
    }

    final productNames = details
        .map((d) => d.product?.title ?? 'Produk')
        .take(2)
        .toList()
        .join(', ');

    final remaining = details.length - 2;
    if (remaining > 0) {
      return '$productNames +$remaining';
    }

    return productNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grayLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Header (Code + Status) ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesanan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayNormal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.externalId ?? order.id.toString(),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadgeWidget(status: order.effectiveStatus),
              ],
            ),

            const SizedBox(height: 16),
            Divider(
              color: AppColors.grayLight,
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 16),

            // ── User Info ────────────────────────────────────────────────
            Text(
              'Pembeli',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.grayNormal,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              order.user?.name ?? 'User Tidak Diketahui',
              style: AppTextStyles.titleSmall.copyWith(
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.user?.email ?? '-',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grayNormal,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 12),
            Divider(
              color: AppColors.grayLight,
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 12),

            // ── Price Section ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayNormal,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  formatCurrency(order.totalPrice),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontFamily: 'Poppins',
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Payment Method ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayNormal,
                    fontFamily: 'Poppins',
                  ),
                ),
                Expanded(
                  child: Text(
                    order.paymentMethodLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grayDark,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Products ────────────────────────────────────────────────
            Text(
              'Produk',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grayNormal,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _buildProductsString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grayDark,
                fontFamily: 'Poppins',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),
            Divider(
              color: AppColors.grayLight,
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 12),

            // ── Dates ───────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Pesanan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayNormal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.createdAtDisplay,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grayDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.paidAt != null && order.paidAt!.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tanggal Dibayar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grayNormal,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.paidAtDisplay,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayDark,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
