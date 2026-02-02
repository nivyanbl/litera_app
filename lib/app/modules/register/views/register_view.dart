import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/theme/app_text_styles.dart';
import 'package:litera/app/core/widgets/custom_button.dart';
import 'package:litera/app/core/widgets/custom_text_field.dart';
import 'package:litera/app/core/widgets/auth_header.dart';
import 'package:litera/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Image Header
              const AuthHeader(),

              // Name field
              Obx(
                () => CustomTextField(
                  hintText: AutofillHints.name,
                  icon: Icons.person_outline,
                  controller: controller.nameC,
                  keyboardType: TextInputType.emailAddress,
                  errorText: controller.emailError.value,
                ),
              ),

              const SizedBox(height: 18),

              // Email field
              Obx(
                () => CustomTextField(
                  hintText: AutofillHints.email,
                  icon: Icons.email_outlined,
                  controller: controller.emailC,
                  keyboardType: TextInputType.emailAddress,
                  errorText: controller.emailError.value,
                ),
              ),

              const SizedBox(height: 18),

              // Password field
              Obx(
                () => CustomTextField(
                  hintText: AutofillHints.password,
                  icon: Icons.lock_outline,
                  controller: controller.passwordC,
                  isPassword: true,
                  errorText: controller.passwordError.value,
                ),
              ),

              const SizedBox(height: 16),

              // Lupa Password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: AppColors.primaryNormal,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Register button
              Obx(
                () => CustomButton(
                  text: "Daftar",
                  onPressed:
                      (controller.isLoading.value ||
                          !controller.isFormValid.value)
                      ? null
                      : controller.register,
                  isLoading: controller.isLoading.value,
                ),
              ),

              const SizedBox(height: 24),

              // Login link
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryNormal,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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
