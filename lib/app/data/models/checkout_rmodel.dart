class CheckoutModel {
  final String message;
  final String invoiceUrl;

  CheckoutModel({
    required this.message,
    required this.invoiceUrl,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      message: json['message'] ?? 'Pesanan berhasil dibuat',
      invoiceUrl: json['invoice_url'] ?? '',
    );
  }
}