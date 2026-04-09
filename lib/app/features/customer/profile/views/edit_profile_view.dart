import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showLeftIcon: true,
        showRightIcon: false,
        onBackPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          // ── Scrollable Content ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── Photo Section ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.grayLightActive,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Obx(
                            () => CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.grayLight,
                              backgroundImage:
                                  controller.selectedImagePath.value.isNotEmpty
                                  ? FileImage(
                                      File(controller.selectedImagePath.value),
                                    )
                                  : controller.displayProfilePicture.isNotEmpty
                                      ? NetworkImage(controller.displayProfilePicture)
                                      : null,
                              child: controller.selectedImagePath.value.isEmpty &&
                                      controller.displayProfilePicture.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 44,
                                      color: AppColors.grayDark,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Upload Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.pickImage(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.grayLightActive,
                                      ),
                                    ),
                                    child: Text(
                                      'Ubah Foto Profil',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Format foto harus .jpg .jpeg , .png dan ukuran file max 2mb',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grayNormal,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Info Pribadi ──────────────────────────────────────────────
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Nama',
                          icon: Icons.person_outline,
                          controller: controller.nameController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hintText: 'Nomer Telepon',
                          icon: Icons.phone_outlined,
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hintText: 'Tanggal Lahir',
                          icon: Icons.calendar_today_outlined,
                          controller: controller.birthDateController,
                          readOnly: true,
                          onTap: () => controller.pickDateOfBirth(),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Divider ───────────────────────────────────────────────────
          Divider(height: 1, color: Colors.grey.shade200),

          // ── Simpan Button (Sticky) ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () async {
                          await controller.updateProfile();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNormal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isUpdating.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
