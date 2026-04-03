import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title, style: AppTextStyles.bodyLarge),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryNormal,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nama Pengguna',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'user@example.com',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grayNormal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Profile Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Profil Saya',
                    onTap: () {
                      // Handle profile edit
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Alamat',
                    onTap: () {
                      // Handle address
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Metode Pembayaran',
                    onTap: () {
                      // Handle payment method
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    onTap: () {
                      // Handle notifications
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan & Support',
                    onTap: () {
                      // Handle help
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileMenuItem(
                    icon: Icons.logout_outlined,
                    title: 'Keluar',
                    onTap: () {
                      // Handle logout
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
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

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? AppColors.errorNormal : AppColors.primaryNormal,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isLogout ? AppColors.errorNormal : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grayNormal,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
