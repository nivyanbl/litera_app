import 'package:dio/dio.dart';
import 'package:litera/app/core/network/api_client.dart';

class AdminDashboardProvider {
  final ApiClient apiClient;

  AdminDashboardProvider({required this.apiClient});

  Future<Map<String, dynamic>> getDashboardData({required int days}) async {
    try {
      final response = await apiClient.get(
        '/admin/dashboard',
        queryParameters: {'days': days},
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch dashboard data');
    }
  }
}
