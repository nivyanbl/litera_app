import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  late final Dio dio;

  static String get baseUrl => dotenv.env['BASE_URL']!;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Accept': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Request Interceptor - Add Authorization Token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle common errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Koneksi timeout. Periksa koneksi internet Anda.',
              ),
            );
          }

          if (error.type == DioExceptionType.connectionError) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error:
                    'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
              ),
            );
          }

          // Handle HTTP errors
          if (error.response != null) {
            final statusCode = error.response!.statusCode;
            String errorMessage = 'Terjadi kesalahan';

            switch (statusCode) {
              case 400:
                errorMessage =
                    error.response!.data['message'] ?? 'Permintaan tidak valid';
                break;
              case 401:
                errorMessage =
                    'Sesi Anda telah berakhir. Silakan login kembali.';
                await SecureStorage.clear();
                break;
              case 403:
                errorMessage = 'Anda tidak memiliki akses';
                break;
              case 404:
                errorMessage = 'Data tidak ditemukan';
                break;
              case 500:
                errorMessage = 'Terjadi kesalahan pada server';
                break;
              default:
                errorMessage =
                    error.response!.data['message'] ?? 'Terjadi kesalahan';
            }

            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                error: errorMessage,
              ),
            );
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Terjadi kesalahan saat mengambil data');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Terjadi kesalahan saat mengirim data');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Terjadi kesalahan saat memperbarui data');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw Exception(e.error ?? 'Terjadi kesalahan saat menghapus data');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
