import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/data/models/order_model.dart';
import 'package:litera/app/features/customer/order_history/widgets/order_status_ui.dart';
import 'package:litera/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPaymentDetailView extends StatefulWidget {
  const OrderPaymentDetailView({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderPaymentDetailView> createState() => _OrderPaymentDetailViewState();
}

class _OrderPaymentDetailViewState extends State<OrderPaymentDetailView> {
  Timer? _countdownTimer;

  static final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _startCountdownIfNeeded();
  }

  @override
  void didUpdateWidget(covariant OrderPaymentDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.externalId != widget.order.externalId ||
        oldWidget.order.createdAt != widget.order.createdAt ||
        oldWidget.order.status != widget.order.status) {
      _startCountdownIfNeeded();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownIfNeeded() {
    _countdownTimer?.cancel();
    if (widget.order.effectiveStatus != 'pending') return;

    final expiresAt = _pendingExpiresAt;
    if (expiresAt == null) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {});
      if (DateTime.now().isAfter(expiresAt)) {
        timer.cancel();
      }
    });
  }

  DateTime? get _pendingExpiresAt {
    final createdAt = widget.order.createdAtDateTime;
    if (createdAt == null) return null;
    return createdAt.add(const Duration(hours: 24));
  }

  Duration? get _remainingDuration {
    final expiresAt = _pendingExpiresAt;
    if (expiresAt == null) return null;
    final diff = expiresAt.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.order.details ?? [];
    final statusUi = OrderStatusUi.from(widget.order.effectiveStatus);
    final status = statusUi.key;
    final isPaid = statusUi.isPaid;
    final isPending = status == 'pending';
    final statusTitle = statusUi.detailTitle;
    final statusColor = statusUi.color;
    final remaining = _remainingDuration;

    final total = widget.order.totalPriceValue;

    return Scaffold(
      backgroundColor: AppColors.grayLight,
      appBar: AppBar(
        title: Text(
          'Detail Pembayaran',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.grayDarker,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.grayDarker,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: statusColor, width: 4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statusTitle,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.grayDarker,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isPending && remaining != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorNormal.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: AppColors.errorNormal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatCountdown(remaining),
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.errorNormal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                _flatSection(
                  children: [
                    _detailRow('ID Transaksi', widget.order.externalId ?? '-'),
                    _detailRow(
                      'Tanggal Transaksi',
                      _formatDateWib(widget.order.createdAtDisplay),
                    ),
                    if (isPending)
                      _detailRow(
                        'Bayar Sebelum',
                        _formatDeadlineWib(_pendingExpiresAt),
                      ),
                    if (isPaid && (widget.order.paidAt ?? '').isNotEmpty)
                      _detailRow(
                        'Waktu Pembayaran',
                        _formatDateWib(widget.order.paidAtDisplay),
                      ),
                    if (isPaid)
                      _detailRow(
                        'Pembayaran',
                        widget.order.isPaymentMethodUnknown
                            ? '${widget.order.paymentMethodLabel} '
                            : widget.order.paymentMethodLabel,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                _sectionBlock(
                  title: 'Detail Pemesanan (${details.length} item)',
                  children: _buildOrderItems(details),
                ),
                const SizedBox(height: 6),
                _sectionBlock(
                  title: 'Rincian Pembayaran',
                  children: [
                    _detailRow(
                      'Total Belanja (${details.length} item)',
                      _currencyFormatter.format(total),
                    ),
                    _detailRow('Biaya Layanan', _currencyFormatter.format(0)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.grayLightActive),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Belanja',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.grayDarker,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _currencyFormatter.format(total),
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: AppColors.grayDarker,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildBottomAction(status),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionBlock({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.grayDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.grayLightActive),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBottomAction(String status) {
    if (status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: Get.back,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: AppColors.primaryNormal,
                side: const BorderSide(color: AppColors.primaryNormal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cek Status'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: AppColors.primaryNormal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final invoiceUrl = widget.order.invoiceUrl;
                if (invoiceUrl == null || invoiceUrl.isEmpty) {
                  Get.snackbar('Error', 'Link pembayaran tidak tersedia');
                  return;
                }

                try {
                  await launchUrl(
                    Uri.parse(invoiceUrl),
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  Get.snackbar('Error', 'Tidak dapat membuka link pembayaran');
                }
              },
              child: const Text('Bayar Sekarang'),
            ),
          ),
        ],
      );
    }

    if (status == 'paid') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            backgroundColor: AppColors.primaryNormal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Get.snackbar('Info', 'Fitur baca buku akan segera tersedia');
          },
          child: const Text('Baca Sekarang'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          backgroundColor: AppColors.primaryNormal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => Get.offAllNamed(Routes.home),
        child: const Text('Beli Lagi'),
      ),
    );
  }

  Widget _flatSection({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.grayLightActive.withValues(alpha: 0.6),
          ),
          bottom: BorderSide(
            color: AppColors.grayLightActive.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _detailRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.grayNormal,
            ),
          ),
          Flexible(
            child: Text(
              right,
              textAlign: TextAlign.right,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.grayDarker,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.grayNormal),
      ),
    );
  }

List<Widget> _buildOrderItems(List<OrderDetailModel> details) {
  if (details.isEmpty) {
    return [
      _detailRow(
        'Item Pesanan',
        _currencyFormatter.format(widget.order.totalPriceValue),
      ),
      _detailText('Informasi detail tidak tersedia'),
    ];
  }

  final widgets = <Widget>[];

  for (var index = 0; index < details.length; index++) {
    final detail = details[index];
    final quantity = detail.quantity ?? 1;
    
    final rawPrice = detail.price;
    final linePrice = rawPrice is String 
        ? (num.tryParse(rawPrice) ?? 0) 
        : (rawPrice ?? 0);

      widgets.add(
        _detailRow(
          detail.product?.title ?? 'Buku',
          _currencyFormatter.format(linePrice),
        ),
      );
      final authorOrType = detail.product?.author?.trim().isNotEmpty == true
          ? detail.product!.author!
          : 'Buku';
      widgets.add(_detailText('$authorOrType • $quantity item'));

      if (index != details.length - 1) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.grayLightActive),
          ),
        );
      }
    }

    return widgets;
  }

  String _formatDateWib(String value) {
    if (value == '-') return value;
    return '$value WIB';
  }

  String _formatDeadlineWib(DateTime? value) {
    if (value == null) return '-';
    final formatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
    return '${formatter.format(value)} WIB';
  }

  String _formatCountdown(Duration duration) {
    final totalHours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$totalHours:$minutes:$seconds';
  }
}
