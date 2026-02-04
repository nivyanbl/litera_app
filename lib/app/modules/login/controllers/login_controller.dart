import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;
  LoginController(this.authRepository);

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isFormValid = false.obs;

  var emailError = Rxn<String>();
  var passwordError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    emailC.addListener(_checkForm);
    passwordC.addListener(_checkForm);
  }

  void _checkForm() {
    isFormValid.value =
        emailC.text.trim().isNotEmpty && passwordC.text.isNotEmpty;

    if (emailC.text.trim().isNotEmpty) emailError.value = null;
    if (passwordC.text.isNotEmpty) passwordError.value = null;
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  Future<void> login() async {
    Get.focusScope?.unfocus();

    emailError.value = null;
    passwordError.value = null;

    final args = Get.arguments as Map?;
    final redirect = args?['redirect'] as String?;
    final redirectArgs = args?['redirectArgs'];

    bool isValid = true;
    final email = emailC.text.trim();
    final password = passwordC.text;

    if (email.isEmpty) {
      emailError.value = "Email wajib diisi";
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Email tidak sesuai";
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = "Password wajib diisi";
      isValid = false;
    }

    if (!isValid) return;

    isLoading.value = true;
    try {
      await authRepository.login(email, password);

      if (redirect != null && redirect.isNotEmpty) {
        Get.offNamed(redirect, arguments: redirectArgs);
        return;
      }

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      final lower = message.toLowerCase();

      if (lower.contains('email')) {
        emailError.value = message;
      } else if (lower.contains('password')) {
        passwordError.value = message;
      } else {
        Get.snackbar("Gagal", message);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
