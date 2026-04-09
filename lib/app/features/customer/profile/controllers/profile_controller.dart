import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;

  ProfileController({required this.repository});

  // ── State ──────────────────────────────────────────────
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Edit-form controllers ──────────────────────────────
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController birthDateController;
  late final TextEditingController emailController;

  // Image picker – hubungkan ke image_picker saat siap
  final RxString selectedImagePath = ''.obs;

  // ── Lifecycle ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    birthDateController = TextEditingController();
    emailController = TextEditingController();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // ── Methods ────────────────────────────────────────────

  Future<void> fetchProfile({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';
    try {
      final data = await repository.fetchProfile();
      user.value = data;
      _populateFormFields(data);
    } catch (e) {
      if (user.value == null) {
        errorMessage.value = e.toString();
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal memuat profil: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  void _populateFormFields(UserModel data) {
    nameController.text = data.name;
    phoneController.text = data.phoneNumber;
    birthDateController.text = data.birthDate;
    emailController.text = data.email;
  }

  /// Dipanggil saat user tap "Simpan" di Edit Profile
  Future<void> updateProfile() async {
    if (isUpdating.value) return;
    isUpdating.value = true;
    try {
      final payload = {
        'name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'birth_date': birthDateController.text.trim(),
      };
      final success = await repository.updateProfile(
        payload,
        selectedImagePath.value.isNotEmpty ? selectedImagePath.value : null,
      );
      if (success) {
        await fetchProfile(showLoading: false);
        Get.back();
        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal memperbarui profil: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();
      // TODO: Sesuaikan route ke halaman login kamu
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// TODO: Sambungkan ke image_picker
  Future<void> pickImage() async {
    // Contoh integrasi image_picker:
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.gallery);
    // if (picked != null) selectedImagePath.value = picked.path;
  }

  // ── Helpers ────────────────────────────────────────────
  String get displayName => user.value?.name ?? '';
  String get displayEmail => user.value?.email ?? '';
  String get displayPhone => (user.value?.phoneNumber.isNotEmpty ?? false)
      ? user.value!.phoneNumber
      : 'Belum Terisi';
  String get displayBirthDate => (user.value?.birthDate.isNotEmpty ?? false)
      ? user.value!.birthDate
      : 'Belum Terisi';
  String get displayProfilePicture => user.value?.profilePicture ?? '';
}
