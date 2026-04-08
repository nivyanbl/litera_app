import 'package:flutter/material.dart';
import 'package:litera/app/core/theme/app_colors.dart';

enum ProductCardVariant { bestSeller, mostCarted }

class ProductCardWidget extends StatelessWidget {
  final int rank;
  final String title;
  final String imageUrl;
  final int count;
  final ProductCardVariant variant;

  const ProductCardWidget({
    super.key,
    required this.rank,
    required this.title,
    required this.imageUrl,
    required this.count,
    this.variant = ProductCardVariant.bestSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank badge
          _RankBadge(rank: rank, variant: variant),
          const SizedBox(width: 12),

          // Product thumbnail
          _ProductThumbnail(imageUrl: imageUrl),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grayDarker,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                _CountBadge(count: count, variant: variant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-components ──────────────────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final int rank;
  final ProductCardVariant variant;

  const _RankBadge({required this.rank, required this.variant});

  @override
  Widget build(BuildContext context) {
    final isTop = rank == 1;
    final color = isTop ? const Color(0xFFFFB020) : AppColors.primaryLight;
    final textColor = isTop ? const Color(0xFF7A5100) : AppColors.primaryNormal;

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        '#$rank',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  final String imageUrl;

  const _ProductThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              // cacheHeight: 100,
              // cacheWidth: 100,
              errorBuilder: (_, _, _) => _PlaceholderIcon(),
            )
          : _PlaceholderIcon(),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.book_rounded, color: AppColors.primaryNormal, size: 22);
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final ProductCardVariant variant;

  const _CountBadge({required this.count, required this.variant});

  @override
  Widget build(BuildContext context) {
    final isSeller = variant == ProductCardVariant.bestSeller;
    final icon = isSeller
        ? Icons.shopping_bag_outlined
        : Icons.shopping_cart_outlined;
    final label = isSeller ? 'terjual' : 'di keranjang';

    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primaryDark),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
