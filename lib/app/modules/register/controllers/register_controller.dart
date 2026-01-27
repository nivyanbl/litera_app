import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litera/app/data/repositories/auth_repository.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthRepository authRepository;
  RegisterController(this.authRepository);

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isFormValid = false.obs;

  var nameError = Rxn<String>();
  var emailError = Rxn<String>();
  var passwordError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    nameC.addListener(_checkForm);
    emailC.addListener(_checkForm);
    passwordC.addListener(_checkForm);
  }

  void _checkForm(){
    isFormValid.value =
        nameC.text.trim().isNotEmpty &&
        emailC.text.trim().isNotEmpty &&
        passwordC.text.isNotEmpty;
    if (nameC.text.trim().isNotEmpty) nameError.value = null;
    if (emailC.text.trim().isNotEmpty) emailError.value = null;
    if (passwordC.text.isNotEmpty) passwordError.value = null;
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  Future<void> register() async {
    Get.focusScope?.unfocus();

    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;

    bool isValid = true;
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text;

    if (name.isEmpty) {
      nameError.value = "Nama wajib diisi";
      isValid = false;
    }

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

    try {
      isLoading.value = true;
      await authRepository.register(name, email, password);
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