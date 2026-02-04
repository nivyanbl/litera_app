import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
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
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          Get.toNamed(
            Routes.PRODUCT_DETAIL,
            arguments: {'product': product, 'imageUrl': imageUrl},
          );
        },
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.grayLightActive),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          padding: const EdgeInsets.all(12), 
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: SizedBox(
                  height: 200, 
                  width: double.infinity, 
                  child: Stack(
                    children: [
                      // Gambar Utama
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: product.image != null && product.image!.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain, 
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.book, size: 40, color: Colors.grey),
                                ),
                        ),
                      ),
                      
                      // Icon Love
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: CircleBorder(),
                            shadows: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))
                            ]
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.author,
                      style: const TextStyle(
                        color: AppColors.grayNormalHover,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 28,
                      child: Text(
                        product.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                    NumberFormat.currency(
                      locale: 'id_ID', 
                      symbol: 'Rp', 
                      decimalDigits: 0
                    ).format(product.price),
                    
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}