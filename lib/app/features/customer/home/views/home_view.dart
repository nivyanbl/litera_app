import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/widgets/shimmer_loading.dart';
import '../controllers/home_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/custom_bottom_navbar.dart';
import '../widgets/home_header.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_section.dart';
import '../widgets/product_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
                const HomeHeader(),
                const SizedBox(height: 20),
                // BANNER CAROUSEL (DENGAN DOTS)
                const BannerCarousel(),
                const SizedBox(height: 24),
                // KATEGORI
                CategorySection(),
                const SizedBox(height: 24),
                //  LIST PRODUK (GRID)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const ShimmerGridBooks(itemCount: 4, crossAxisCount: 2);
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
                            childAspectRatio: 0.54,
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

                        return ProductCard(
                          product: product,
                          imageUrl: imageUrl,
                        );
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
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.offNamed('/order-history');
          } else if (index == 2) {
            Get.offNamed('/profile');
          }
        },
      ),
    );
  }
}
