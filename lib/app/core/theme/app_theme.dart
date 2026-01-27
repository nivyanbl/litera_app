import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Font
      fontFamily: 'Poppins',
      primaryColor: AppColors.primaryNormal,
      useMaterial3: true,

      // Color
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryNormal,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        onSecondary: Colors.white,
        error: AppColors.errorNormal,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: AppColors.grayDark,
      ),

      // Button Styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNormal,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.grayLightHover,
          disabledForegroundColor: AppColors.grayLightActive,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20)
        )
      ),

      // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: AppColors.grayNormal,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayNormal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayNormal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryNormal,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.errorNormal,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.errorNormal,
            width: 1,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorNormal,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
