import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:litera/app/core/network/api_client.dart';
import 'package:litera/app/core/services/download_service.dart';
import 'package:litera/app/core/services/auth_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

Future<String> _getInitialRoute() async {
  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();

  if (!isLoggedIn) {
    return Routes.home;
  }

  // Jika sudah login, cek role
  final isAdmin = await authService.isAdmin();
  if (isAdmin) {
    return Routes.adminDashboard;
  }

  // User biasa ke Profile
  return Routes.profile;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  imageCache.maximumSizeBytes = 50 * 1024 * 1024;
  imageCache.maximumSize = 100;

  // Inisialisasi services global
  Get.put(ApiClient(), permanent: true);
  Get.put(DownloadService(), permanent: true);

  // Tentukan initial route berdasarkan login status
  final initialRoute = await _getInitialRoute();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "litera",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme.copyWith(
        appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),
  );
}
