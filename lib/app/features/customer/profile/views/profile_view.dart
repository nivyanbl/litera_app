import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/core/widgets/custom_app_bar.dart';
import 'package:litera/app/core/widgets/custom_bottom_navbar.dart';
import 'package:litera/app/features/customer/profile/controllers/profile_controller.dart';
import 'package:litera/app/features/customer/profile/views/edit_profile_view.dart';
import 'package:litera/app/features/customer/profile/widgets/profile_info_tile.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile",
        showLeftIcon: false,
        showRightIcon: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchProfile(showLoading: false),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                controller.errorMessage.value.isNotEmpty &&
                    controller.user.value == null
                ? _ErrorState(
                    message: controller.errorMessage.value,
                    onRetry: () => Get.offAllNamed(Routes.login),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile Card ──────────────────────────────
                      _ProfileCard(controller: controller),
                      const SizedBox(height: 24),

                      // ── Info Pribadi ──────────────────────────────
                      Text(
                        'Info Pribadi',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              ProfileInfoTile(
                                icon: Icons.person_outline,
                                label: 'Nama',
                                value: controller.displayName.isNotEmpty
                                    ? controller.displayName
                                    : 'Belum diisi',
                              ),
                              ProfileInfoTile(
                                icon: Icons.phone_outlined,
                                label: 'Nomer Telepon',
                                value: controller.displayPhone,
                              ),
                              ProfileInfoTile(
                                icon: Icons.calendar_today_outlined,
                                label: 'Tanggal Lahir',
                                value: controller.displayBirthDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Log Out ───────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _confirmLogout(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorNormal,
                            side: const BorderSide(
                              color: AppColors.errorNormal,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.errorNormal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Get.offNamed('/home');
          } else if (index == 1) {
            Get.offNamed('/order-history');
          }
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Kamu yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Ya, Keluar',
              style: TextStyle(color: AppColors.errorNormal),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Card Widget ─────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.grayLightActive),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Obx(
              () => _ProfileAvatar(imageUrl: controller.displayProfilePicture),
            ),
            const SizedBox(width: 12),

            // Name & Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Pengguna",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.displayEmail.isNotEmpty
                        ? controller.displayEmail
                        : '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grayDarker,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Ubah Button
            OutlinedButton.icon(
              onPressed: () {
                Get.to(() => const EditProfileView());
              },
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text(
                'Ubah',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: AppColors.grayLightActive),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                textStyle: AppTextStyles.labelSmall,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar ──────────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Get.log('🖼️ Avatar - imageUrl: $imageUrl, isEmpty: ${imageUrl.isEmpty}');
    
    return CircleAvatar(
      radius: 40,
      backgroundColor: AppColors.grayLight,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      onBackgroundImageError: imageUrl.isNotEmpty ? (_, __) {
        Get.log('❌ Error loading image: $imageUrl');
      } : null,
      child: imageUrl.isEmpty
          ? const Icon(Icons.person, size: 40, color: AppColors.grayDark)
          : null,
    );
  }
}

// ── Error State ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.errorNormal,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
