import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryBlue),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        background: AppColors.backgroundLight,
        surface: AppColors.backgroundLight,
        surfaceContainerLow: AppColors.surfaceLight,
        surfaceContainerHigh: Color(0xFFF1F5F9),
        outlineVariant: AppColors.lightGrey,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryBlue),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        background: AppColors.backgroundDark,
        surface: AppColors.backgroundDark,
        surfaceContainerLow: AppColors.surfaceDark,
        surfaceContainerHigh: Color(0xFF334155),
        outlineVariant: Color(0xFF334155), 
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
      ),
    );
  }

  static ThemeData get orangeTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0B0F19),
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF161F30),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.accentOrange),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentOrange,
        onPrimary: AppColors.white,
        background: Color(0xFF0B0F19),
        surface: Color(0xFF0B0F19),
        surfaceContainerLow: Color(0xFF161F30),
        surfaceContainerHigh: Color(0xFF24324A),
        outlineVariant: Color(0xFF24324A),
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
      ),
    );
  }
}