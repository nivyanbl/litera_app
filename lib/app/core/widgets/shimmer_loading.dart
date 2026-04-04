import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// =====================================================================
// 1. WIDGET KERANGKA (SKELETON)
// =====================================================================

class SkeletonBookCard extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonBookCard({
    super.key,
    this.width,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SkeletonCartItem extends StatelessWidget {
  const SkeletonCartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: double.infinity, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                Container(height: 12, width: 200, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                Container(height: 12, width: 150, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SkeletonCheckoutItem extends StatelessWidget {
  const SkeletonCheckoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 150, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                Container(height: 12, width: double.infinity, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                Container(height: 12, width: 100, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 2. PEMBUNGKUS SHIMMER (VERSI PERBAIKAN ERROR)
// =====================================================================

class ShimmerBookList extends StatelessWidget {
  final int itemCount;
  final Axis direction;

  const ShimmerBookList({
    super.key,
    this.itemCount = 5,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        // PERBAIKAN: Menambahkan shrinkWrap dan physics agar tidak error di dalam Column
        shrinkWrap: true, 
        physics: direction == Axis.vertical 
            ? const NeverScrollableScrollPhysics() 
            : const ScrollPhysics(),
        scrollDirection: direction,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: direction == Axis.horizontal ? 16.0 : 0,
              bottom: direction == Axis.vertical ? 12.0 : 0,
            ),
            child: direction == Axis.horizontal 
                ? const SkeletonBookCard(width: 150) 
                : const SkeletonCartItem(),
          );
        },
      ),
    );
  }
}

class ShimmerGridBooks extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const ShimmerGridBooks({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    // Shimmer DIPANGGIL SEKALI SAJA DI SINI!
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) =>
            const SkeletonBookCard(height: 220, width: double.infinity),
      ),
    );
  }
}

// Halaman Detail Produk juga cukup dibungkus satu kali di induknya
class ShimmerProductDetail extends StatelessWidget {
  const ShimmerProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              Container(height: 24, width: 250, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
              Container(height: 18, width: 150, color: Colors.white, margin: const EdgeInsets.only(bottom: 20)),
              ...List.generate(
                4,
                (index) => Container(
                  height: 12, 
                  width: double.infinity, 
                  color: Colors.white, 
                  margin: const EdgeInsets.only(bottom: 10)
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: List.generate(
                  2,
                  (index) => Expanded(
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(right: index == 0 ? 12 : 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}