import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as picker;
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;
  ProfileController({required this.repository}); // Dependency Injection

  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var title = 'Profil Saya'.obs;

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();

  var selectedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final userData = await repository.fetchProfile();
      user.value = userData;

      nameController.text = userData.name;
      emailController.text = userData.email;
      phoneController.text = userData.phoneNumber;
      birthDateController.text = userData.birthDate;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.ImagePicker().pickImage(
      source: picker.ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      // Validasi input
      if (nameController.text.isEmpty) {
        Get.snackbar('Error', 'Nama tidak boleh kosong');
        isLoading.value = false;
        return;
      }

      // Siapkan data - hanya kirim data yang tidak kosong
      Map<String, dynamic> data = {'name': nameController.text};

      // Tambah email jika tidak kosong
      if (emailController.text.isNotEmpty) {
        data['email'] = emailController.text;
      }

      // Tambah phone_number jika tidak kosong
      if (phoneController.text.isNotEmpty) {
        data['phone_number'] = phoneController.text;
      }

      // Tambah birth_date jika tidak kosong dan format valid (YYYY-MM-DD)
      if (birthDateController.text.isNotEmpty) {
        // Validasi format date
        try {
          DateTime.parse(birthDateController.text);
          data['birth_date'] = birthDateController.text;
        } catch (e) {
          Get.snackbar(
            'Error',
            'Format tanggal tidak valid (gunakan YYYY-MM-DD)',
          );
          isLoading.value = false;
          return;
        }
      }

      // Panggil repository
      bool isSuccess = await repository.updateProfile(
        data,
        selectedImagePath.value,
      );

      if (isSuccess) {
        Get.snackbar('Berhasil', 'Profil kamu sudah diperbarui');
        loadProfile(); // Refresh tampilan dengan data baru
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan saat mengupdate profil');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await repository.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
