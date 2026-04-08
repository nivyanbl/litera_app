import 'package:get/get.dart';

import '../models/user_model.dart';
import '../providers/profile_provider.dart';

class ProfileRepository {
  final ProfileProvider provider;

  ProfileRepository({required this.provider});

  Future<UserModel> fetchProfile() async {
    try {
      final userData = await provider.getProfile();
      return userData;
    } catch (e) {
      throw Exception('Gagal mengambil data profil: ${e.toString()}');
    }
  }

  Future<bool> updateProfile(
    Map<String, dynamic> data,
    String? imagePath,
  ) async {
    try {
      await provider.updateProfile(data: data, imagePath: imagePath);
      return true;
    } catch (e) {
      Get.log('Exception in updateProfile: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await provider.logout();
    } catch (e) {
      Get.log('Error logging out: $e');
      rethrow;
    }
  }
}
