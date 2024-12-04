import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'app_colors.dart';

const Color settingsTileTextColor = AppColors.white;

// ignore: non_constant_identifier_names
ThemeData dark_theme() => ThemeData(
      // scaffoldBackgroundColor: const Color(0xff09101D),
      scaffoldBackgroundColor: const Color(0xff121212),
      primaryColor: AppColors.primary,
      cardColor: const Color(0xff1B1E23),
      // canvasColor: const Color(0xff1B1E23),
      canvasColor: const Color(0xff09101D),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xff09101D),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xff1B1E23),
      ),
      dividerColor: AppColors.white,
      tabBarTheme: TabBarTheme(
        labelStyle: Typo.bodySmall.copyWith(fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            Typo.bodySmall.copyWith(fontWeight: FontWeight.w500),
        indicatorColor: AppColors.primary,
        labelColor: AppColors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: AppColors.white.withOpacity(0.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.greyDark,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintStyle: Typo.bodyLarge.copyWith(
          color: AppColors.slightlyDarkGray.withOpacity(0.45),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.white,
            width: 2,
          ),
          gapPadding: 0,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.greyLight.withOpacity(1.0),
        surfaceTintColor: AppColors.greyDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.blueLight,
      ),
      appBarTheme: const AppBarTheme(
        // color: Color(0xff1B1E23),
        color: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarDividerColor: AppColors.darkBlue,
          systemNavigationBarColor: AppColors.darkBlue,
          systemStatusBarContrastEnforced: true,
          statusBarColor: AppColors.darkBlue,
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
      ),
      brightness: Brightness.dark,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: AppColors.white),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        displayLarge: Typo.displayLarge,
        displayMedium: Typo.displayMedium,
        displaySmall: Typo.displaySmall,
        headlineLarge: Typo.headlineLarge,
        headlineMedium: Typo.headlineMedium,
        headlineSmall: Typo.headlineSmall,
        titleLarge: Typo.titleLarge,
        titleMedium: Typo.titleMedium,
        titleSmall: Typo.titleSmall,
        bodyLarge: Typo.bodyLarge,
        bodyMedium: Typo.bodyMedium,
        bodySmall: Typo.bodySmall,
        labelLarge: Typo.labelLarge,
        labelSmall: Typo.labelSmall,
      ),
      iconTheme: const IconThemeData(color: AppColors.greyLight),
      colorScheme: const ColorScheme.dark(),
      dialogBackgroundColor: const Color(0xff1B1E23),
    );
