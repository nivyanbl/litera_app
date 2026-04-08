import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final hasImage =
        product.image != null &&
        product.image!.isNotEmpty &&
        (product.image!.startsWith('http://') ||
            product.image!.startsWith('https://'));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 128,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book Cover
            _buildBookCover(hasImage),
            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Badge
                  if (product.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category!.name,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Author
                  Text(
                    product.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price & Stock Row
                  Row(
                    children: [
                      // Price
                      Text(
                        priceFormat.format(product.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Stock Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: product.stock > 0
                                ? Colors.green.shade300
                                : Colors.red.shade300,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              product.stock > 0
                                  ? Icons.check_circle
                                  : Icons.cancel_outlined,
                              size: 12,
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.stock > 0
                                  ? 'Stock ${product.stock}'
                                  : 'Out',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: product.stock > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
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

            const SizedBox(width: 8),

            // Delete Button
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300, width: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(bool hasImage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 76,
        height: 104,
        color: const Color(0xFFF1F5FB),
        child: hasImage
            ? Image.network(
                product.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.menu_book_rounded,
                  size: 32,
                  color: Color(0xFF4A90E2),
                ),
              )
            : const Icon(
                Icons.menu_book_rounded,
                size: 32,
                color: Color(0xFF4A90E2),
              ),
      ),
    );
  }
}
