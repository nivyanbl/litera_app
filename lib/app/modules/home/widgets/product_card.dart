import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String imageUrl;

  const ProductCard({super.key, required this.product, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Get.toNamed(
            Routes.PRODUCT_DETAIL,
            arguments: {'product': product, 'imageUrl': imageUrl},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              product.image != null && product.image!.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.book,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      right: 28,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Penulis
                    Text(
                      product.author,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grayNormal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                    SizedBox(
                      height: 38,
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Harga
                    Text(
                      "Rp ${product.price.toStringAsFixed(0)}",
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
