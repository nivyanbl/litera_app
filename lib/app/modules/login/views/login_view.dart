import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/widgets/custom_button.dart';
import 'package:litera/app/core/widgets/custom_text_field.dart';
import 'package:litera/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
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
              SizedBox(height: 150),

              // Logo Litera
              Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // woman reading image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/woman_reading.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 48),

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

              const SizedBox(height: 24),

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

              // Login button
              Obx(
                () => CustomButton(
                  text: "Masuk",
                  onPressed:
                      (controller.isLoading.value ||
                          !controller.isFormValid.value)
                      ? null
                      : controller.login,
                  isLoading: controller.isLoading.value,
                ),
              ),

              const SizedBox(height: 24),

              // Register link
             
            ],
          ),
        ),
      ),
    );
  }
}
