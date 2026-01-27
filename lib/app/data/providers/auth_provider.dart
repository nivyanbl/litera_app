import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthProvider {
  final ApiClient _client;

  AuthProvider(this._client);

  Future<UserModel> login(String email, String password) async {
    try {
      final res = await _client.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (res.data == null) {
        throw Exception("Response tidak valid");
      }

      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final res = await _client.dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (res.data == null) {
        throw Exception("Response tidak valid");
      }

      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;

    if (e.response?.statusCode == 422 && data is Map && data['errors'] is Map) {
      for (final value in (data['errors'] as Map).values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
      }
    }

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    return "Gagal terhubung ke server";
  }
}
