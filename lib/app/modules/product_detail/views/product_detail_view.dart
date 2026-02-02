import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  bool _isExpanded = false;

  ProductModel get _product {
    final args = Get.arguments as Map?;
    return args?['product'] as ProductModel;
  }

  String get _imageUrl {
    final args = Get.arguments as Map?;
    final argUrl = args?['imageUrl'] as String?;
    if (argUrl != null && argUrl.isNotEmpty) {
      return argUrl;
    }

    final image = _product.image;
    if (image == null || image.isEmpty) return '';

    if (image.startsWith('http')) return image;

    final baseUrl = ApiClient.baseUrl.replaceAll('/api', '');
    final cleanImageName = image.replaceAll('public/', '');

    if (cleanImageName.startsWith('storage/')) {
      return "$baseUrl/$cleanImageName";
    }

    return "$baseUrl/storage/$cleanImageName";
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.grayLight,
                        ),
                        child: _imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.book,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.title,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Rp ${product.price.toStringAsFixed(0)}",
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description?.trim().isNotEmpty == true
                          ? product.description!.trim()
                          : "Deskripsi belum tersedia.",
                      maxLines: _isExpanded ? null : 4,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grayDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _isExpanded ? "Tutup" : "Baca Selengkapnya",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryNormal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.primaryNormal,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Informasi Buku",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      leftTitle: "Bahasa",
                      leftValue: product.language.isNotEmpty
                          ? product.language
                          : "-",
                      rightTitle: "Tanggal Rilis",
                      rightValue: product.publishedAt.isNotEmpty
                          ? product.publishedAt
                          : "-",
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      leftTitle: "Halaman",
                      leftValue: product.pages.isNotEmpty ? product.pages : "-",
                      rightTitle: "Jenis Edisi",
                      rightValue: "Reguler",
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryNormal),
                        foregroundColor: AppColors.primaryNormal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text("Beli Sekarang"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNormal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text("+Keranjang"),
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
}

class _InfoRow extends StatelessWidget {
  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;

  const _InfoRow({
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoItem(title: leftTitle, value: leftValue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InfoItem(title: rightTitle, value: rightValue),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grayNormal),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
