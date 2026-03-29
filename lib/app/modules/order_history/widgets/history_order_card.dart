import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/modules/order_history/widgets/order_status_ui.dart';
import 'package:litera/app/modules/order_history/widgets/order_thumbnail.dart';

class HistoryOrderCard extends StatefulWidget {
  const HistoryOrderCard({super.key, required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  State<HistoryOrderCard> createState() => _HistoryOrderCardState();
}

class _HistoryOrderCardState extends State<HistoryOrderCard> {
  bool _showAllItems = false;

  static final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final item = widget.order.firstDetail;
    final details = widget.order.details ?? const [];
    final totalItems = details.length;
    final statusUi = OrderStatusUi.from(widget.order.effectiveStatus);
    final isPending = statusUi.key == 'pending';
    final statusLabel = statusUi.historyLabel;
    final statusColor = statusUi.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayLightActive),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order.createdAtDisplay,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.grayNormal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'ID Transaksi ${widget.order.externalId ?? '-'}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.grayDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  if (widget.order.externalId != null) {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: widget.order.externalId!,
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: AppColors.grayNormal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    height: 20,
                    color: AppColors.grayLightActive,
                    thickness: 0.5,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OrderThumbnail(
                        imageUrl: item?.product?.image,
                        width: 54,
                        height: 72,
                        borderRadius: 6,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item?.product?.title ??
                              'Pesanan #${widget.order.externalId}',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.grayDarker,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (totalItems > 1) ...[
              const SizedBox(height: 8),
              if (!_showAllItems)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _showAllItems = true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat Semua',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.grayDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.grayDark,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_showAllItems) ...[
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                ...details
                    .skip(1)
                    .map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OrderThumbnail(
                              imageUrl: detail.product?.image,
                              width: 54,
                              height: 72,
                              borderRadius: 6,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                detail.product?.title ?? 'Produk',
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.grayDarker,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _showAllItems = false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tampilkan Ringkas',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.grayDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 18,
                          color: AppColors.grayDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),

                  Text(
                    'Total Pembayaran',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.grayNormal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(widget.order.totalPriceValue),
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.grayDarker,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  if (!(isPending && widget.order.isPaymentMethodUnknown))
                    Text(
                      widget.order.paymentMethodLabel,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: widget.order.isPaymentMethodUnknown
                            ? AppColors.warningNormal
                            : AppColors.grayDark,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double value) {
    final amount = value;
    return _currencyFormatter.format(amount);
  }
}
