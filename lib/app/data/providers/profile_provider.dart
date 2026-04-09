import 'package:dio/dio.dart';
import 'package:litera/app/core/network/api_client.dart';
import '../models/user_model.dart';

class ProfileProvider {
  final ApiClient apiClient;

  ProfileProvider(this.apiClient);

  // GET Profile
  Future<UserModel> getProfile() async {
    final response = await apiClient.get('/profile');

    if (response.data == null) throw Exception('Data profil tidak ditemukan');
    final data = response.data['data'] ?? response.data;

    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  // UPDATE Profile (menggunakan MultipartRequest karena ada gambar)
  Future<UserModel> updateProfile({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    FormData formData = FormData();

    // Add text fields - skip null/empty values
    data.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    // Masukkan file gambar jika ada
    if (imagePath != null && imagePath.isNotEmpty) {
      formData.files.add(
        MapEntry('profile_picture', await MultipartFile.fromFile(imagePath)),
      );
    }

    final response = await apiClient.post('/profile/update', data: formData);

    if (response.data == null) throw Exception('Gagal mengupdate profil');
    final responseData = response.data['data'] ?? response.data;

    return UserModel.fromJson(responseData as Map<String, dynamic>);
  }

  // LOGOUT
  Future<void> logout() async {
    await apiClient.post('/logout');
  }
}
