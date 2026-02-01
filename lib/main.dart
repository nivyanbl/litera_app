import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:litera/app/core/network/api_client.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env.dev");

  Get.put(ApiClient(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "litera",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      theme: AppTheme.lightTheme,
    ),
  );
}
