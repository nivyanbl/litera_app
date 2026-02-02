import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class BannerCarousel extends GetView<HomeController> {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
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
}
