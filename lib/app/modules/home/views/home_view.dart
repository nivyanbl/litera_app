import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/home_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/product_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  (Logo & Search)
                _buildHeader(),
                const SizedBox(height: 20),
                // BANNER CAROUSEL (DENGAN DOTS)
                _buildBannerCarousel(),
                const SizedBox(height: 24),
                // KATEGORI
                _buildCategories(),
                const SizedBox(height: 24),
                //  LIST PRODUK (GRID)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // Cek Data
                    if (controller.productList.isEmpty) {
                      return const Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text("Produk tidak ditemukan"),
                          ],
                        ),
                      );
                    }

                    // Tampilkan Grid
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: controller.productList.length,
                      itemBuilder: (context, index) {
                        final product = controller.productList[index];

                        String imageUrl = "";
                        if (product.image != null &&
                            product.image!.isNotEmpty) {
                          if (product.image!.startsWith('http')) {
                            imageUrl = product.image!;
                          } else {
                            String baseUrl = ApiClient.baseUrl.replaceAll(
                              '/api',
                              '',
                            );
                            String cleanImageName = product.image!.replaceAll(
                              'public/',
                              '',
                            );

                            if (cleanImageName.startsWith('storage/')) {
                              imageUrl = "$baseUrl/$cleanImageName";
                            } else {
                              imageUrl = "$baseUrl/storage/$cleanImageName";
                            }
                          }
                        }

                        return _buildProductCard(product, imageUrl);
                      },
                    );
                  }),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  (Logo & Search)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: AppTextStyles.labelLarge,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          const SizedBox(width: 10),
          const Icon(Icons.favorite_outline, color: Colors.black87),
        ],
      ),
    );
  }

  // BANNER CAROUSEL (DENGAN DOTS)
  Widget _buildBannerCarousel() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryNormalHover,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    controller.onBannerChanged(index);
                  },
                ),
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 300,
                        child: Image.asset(
                          'assets/images/banner.png',
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Obx(
                () => AnimatedSmoothIndicator(
                  activeIndex: controller.currentBannerIndex.value,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 7,
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // KATEGORI
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategori Buku",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Lihat Semua",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grayDark,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _categoryChip("Novel"),
              _categoryChip("Komik"),
              _categoryChip("Pelajaran"),
              _categoryChip("Biografi"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.white,
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, String imageUrl) {
    return Container(
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
                      child: product.image != null && product.image!.isNotEmpty
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Penulis
                Text(
                  product.author ?? "Penulis",
                  style: AppTextStyles.labelMedium.copyWith(
                    color:AppColors.grayNormal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),
                SizedBox(
                  height: 38, 
                  child: Text(
                    product.title ?? "Tanpa Judul",
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
                  "Rp ${product.price?.toStringAsFixed(0) ?? '0'}",
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
    );
  }
}
