import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Akun',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Profile Card ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            GestureDetector(
                              onTap: () => controller.pickImage(),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.primaryNormal,
                                backgroundImage:
                                    controller
                                        .selectedImagePath
                                        .value
                                        .isNotEmpty
                                    ? FileImage(
                                        File(
                                          controller.selectedImagePath.value,
                                        ),
                                      )
                                    : null,
                                child:
                                    controller.selectedImagePath.value.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Name & Email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.user.value?.name ??
                                        'Profil Pengguna',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.user.value?.email ??
                                        'user@example.com',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Edit Button
                            OutlinedButton.icon(
                              onPressed: () => Get.toNamed('/edit-profile'),
                              icon: const Icon(Icons.edit_outlined, size: 14),
                              label: const Text('Ubah'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: BorderSide(color: Colors.grey.shade400),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(fontSize: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Info Pribadi ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Info Pribadi',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildInfoItem(
                            icon: Icons.person_outline,
                            label: 'Nama',
                            value:
                                controller.user.value?.name ?? 'Belum Terisi',
                          ),
                          const Divider(height: 1, indent: 56),
                          _buildInfoItem(
                            icon: Icons.phone_outlined,
                            label: 'Nomer Telepon',
                            value:
                                controller.user.value?.phoneNumber ??
                                'Belum Terisi',
                          ),
                          const Divider(height: 1, indent: 56),
                          _buildInfoItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Tanggal Lahir',
                            value:
                                controller.user.value?.birthDate ??
                                'Belum Terisi',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Log Out Button ────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showLogoutDialog(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorNormal,
                            side: BorderSide(color: AppColors.errorNormal),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.errorNormal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grayNormal, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grayNormal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          Obx(
            () => TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      Get.back();
                      await controller.logout();
                    },
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Keluar',
                      style: TextStyle(color: AppColors.errorNormal),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
