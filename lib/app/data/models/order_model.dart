import 'package:intl/intl.dart';

class OrderModel {
  static const _unknownPaymentMethodLabel = 'Metode Tidak Diketahui';
  static final _displayDateFormatter = DateFormat(
    'd MMMM yyyy, HH:mm',
    'id_ID',
  );

  int? id;
  String? externalId;
  String? totalPrice;
  String? status;
  String? invoiceUrl;
  String? paymentMethod;
  bool? isDownloaded;
  String? paidAt;
  String? createdAt;
  List<OrderDetailModel>? details;

  OrderModel({
    this.id,
    this.externalId,
    this.totalPrice,
    this.status,
    this.invoiceUrl,
    this.paymentMethod,
    this.isDownloaded,
    this.paidAt,
    this.createdAt,
    this.details,
  });

  OrderDetailModel? get firstDetail =>
      (details?.isNotEmpty ?? false) ? details!.first : null;

  double get totalPriceValue =>
      num.tryParse(totalPrice ?? '0')?.toDouble() ?? 0;

  String get createdAtDisplay => _cleanDateTime(createdAt);

  String get paidAtDisplay => _cleanDateTime(paidAt);

  DateTime? get createdAtDateTime {
    final value = createdAt;
    if (value == null || value.isEmpty) return null;
    return _tryParseDateTime(value)?.toLocal();
  }

  String get effectiveStatus {
    final normalized = (status ?? '').toLowerCase();
    if (normalized != 'pending') return normalized;

    final created = createdAtDateTime;
    if (created == null) return normalized;

    final expiredAt = created.add(const Duration(hours: 24));
    return DateTime.now().isAfter(expiredAt) ? 'failed' : 'pending';
  }

  String get paymentMethodLabel {
    final raw = paymentMethod?.trim();
    if (raw == null || raw.isEmpty) return _unknownPaymentMethodLabel;
    return raw.replaceAll(RegExp(r'[_-]+'), ' ').toUpperCase();
  }

  bool get isPaymentMethodUnknown {
    final raw = paymentMethod?.trim();

    return raw == null || raw.isEmpty;
  }

  bool get canReadBook => isDownloaded == true;

  static String _cleanDateTime(String? value) {
    if (value == null || value.isEmpty) return '-';

    final parsed = _tryParseDateTime(value);
    if (parsed == null) return value;

    try {
      return _displayDateFormatter.format(parsed.toLocal());
    } catch (e) {
      return value;
    }
  }

  static DateTime? _tryParseDateTime(String value) {
    return DateTime.tryParse(value.trim().replaceAll(' ', 'T'));
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      externalId: json['external_id'],
      totalPrice: json['total_price']?.toString(),
      status: json['status'],
      invoiceUrl: json['invoice_url'],
      paymentMethod: json['payment_method'],
      isDownloaded: json['is_downloaded'] == true || json['downloaded'] == true,
      paidAt: json['paid_at'],
      createdAt: json['created_at'],
      details: json['details'] != null
          ? (json['details'] as List)
                .whereType<Map<String, dynamic>>()
                .map(OrderDetailModel.fromJson)
                .toList()
          : null,
    );
  }
}

class OrderDetailModel {
  int? id;
  int? productId;
  int? quantity;
  String? price;
  OrderProductModel? product;

  OrderDetailModel({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.product,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      product: json['product'] != null
          ? OrderProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class OrderProductModel {
  int? id;
  String? title;
  String? image;
  String? author;

  OrderProductModel({this.id, this.title, this.image, this.author});

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      author: json['author'],
    );
  }
}
