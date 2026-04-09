import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
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
    // Initialize Indonesian locale for date formatting
    _initializeIndonesianLocale();
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
      
      // DEBUG: Log profile picture
      Get.log('✅ Profile fetched - Picture: ${data.profilePicture}');
      
      _populateFormFields(data);
    } catch (e) {
      Get.log('❌ Error fetch profile: $e');
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
    emailController.text = data.email;
    
    // Format dan tampilkan birth date dari profile
    if (data.birthDate.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(data.birthDate);
        birthDateController.text = _formatDateIndonesian(dateTime);
      } catch (e) {
        birthDateController.text = data.birthDate;
      }
    }
  }

  /// Dipanggil saat user tap "Simpan" di Edit Profile
  Future<void> updateProfile() async {
    if (isUpdating.value) return;
    isUpdating.value = true;
    try {
      // Convert Indonesian formatted date back to yyyy-MM-dd for API
      final birthDateForAPI = _convertIndonesianDateToStandard(
        birthDateController.text.trim(),
      );
      
      final payload = {
        'name': nameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'birth_date': birthDateForAPI,
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
    final ImagePicker picker = ImagePicker();
    
    // Show dialog untuk pilih sumber gambar
    Get.dialog(
      AlertDialog(
        title: const Text('Pilih Sumber Foto'),
        content: const Text('Dari mana Anda ingin memilih foto?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _pickImageFromGallery(picker);
            },
            child: const Text('Galeri'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _pickImageFromCamera(picker);
            },
            child: const Text('Kamera'),
          ),
        ],
      ),
    );
  }

  /// Pick image dari gallery
  Future<void> _pickImageFromGallery(ImagePicker picker) async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        selectedImagePath.value = picked.path;
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal memilih gambar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pick image dari camera
  Future<void> _pickImageFromCamera(ImagePicker picker) async {
    try {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        selectedImagePath.value = picked.path;
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pick date dan format sebagai "18 agus 2023"
  Future<void> pickDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _parseDate(birthDateController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      birthDateController.text = _formatDateIndonesian(pickedDate);
    }
  }

  /// Format tanggal ke format Indonesian "dd MMM yyyy" (18 agus 2023)
  String _formatDateIndonesian(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Parse tanggal dari string format "dd MMMM yyyy"
  DateTime _parseDate(String dateString) {
    try {
      // Coba parse format standar dulu (yyyy-MM-dd)
      return DateTime.parse(dateString);
    } catch (e) {
      // Default ke 18 tahun yang lalu dari hari ini
      return DateTime.now().subtract(const Duration(days: 365 * 18));
    }
  }

  /// Convert format Indonesian "18 agus 2023" ke "2023-08-18"
  String _convertIndonesianDateToStandard(String indonesianDate) {
    try {
      // Jika sudah format standar, return as is
      if (indonesianDate.contains('-')) {
        return indonesianDate;
      }
      
      // Parse dari format Indonesian
      final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
      final dateTime = formatter.parse(indonesianDate);
      
      // Return dalam format yyyy-MM-dd
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      // Jika gagal parse, return original value
      return indonesianDate;
    }
  }

  /// Initialize Indonesian locale for date formatting
  Future<void> _initializeIndonesianLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
    } catch (e) {
      Get.log('Error initializing Indonesian locale: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────
  String get displayName => user.value?.name ?? '';
  String get displayEmail => user.value?.email ?? '';
  String get displayPhone => (user.value?.phoneNumber.isNotEmpty ?? false)
      ? user.value!.phoneNumber
      : 'Belum Terisi';
  String get displayBirthDate {
    if (user.value?.birthDate.isEmpty ?? true) {
      return 'Belum Terisi';
    }
    try {
      final dateTime = DateTime.parse(user.value!.birthDate);
      return _formatDateIndonesian(dateTime);
    } catch (e) {
      return user.value!.birthDate;
    }
  }
  String get displayProfilePicture {
    final profilePicture = user.value?.profilePicture ?? '';
    if (profilePicture.isEmpty) return '';
    
    // Jika sudah full URL dengan http/https, return as is
    if (profilePicture.startsWith('http://') || 
        profilePicture.startsWith('https://')) {
      return profilePicture;
    }
    
    // Jika path relatif dari Laravel Storage, tambahkan storage/ dan domain
    // Path dari backend: "profiles/uuid.png" → "https://literaid.app/storage/profiles/uuid.png"
    return 'https://literaid.app/storage/$profilePicture';
  }
}
