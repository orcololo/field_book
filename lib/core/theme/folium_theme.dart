import 'package:flutter/material.dart';

/// Folium Design System - Eco-Modern Theme
/// Blends Apple HIG with organic design principles
class FoliumTheme {
  // Prevent instantiation
  FoliumTheme._();

  // ========== COLOR PALETTE ==========
  
  // Primary - Botanical Green
  static const Color primaryLight = Color(0xFF2D5F3F);
  static const Color primaryMain = Color(0xFF3D7A52);
  static const Color primaryDark = Color(0xFF234A30);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF1A3D27);

  // Secondary - Earth Tones
  static const Color secondaryLight = Color(0xFF8D6E63);
  static const Color secondaryMain = Color(0xFF6D4C41);
  static const Color secondaryDark = Color(0xFF5D4037);
  static const Color secondaryContainer = Color(0xFFEFEBE9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF3E2723);

  // Tertiary - Sky & Water
  static const Color tertiaryLight = Color(0xFF4FC3F7);
  static const Color tertiaryMain = Color(0xFF0288D1);
  static const Color tertiaryDark = Color(0xFF01579B);
  static const Color tertiaryContainer = Color(0xFFE1F5FE);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF01579B);

  // Surface & Background
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFECEFF1);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Outlines
  static const Color outline = Color(0xFFDDDDDD);
  static const Color outlineVariant = Color(0xFFE8E8E8);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // ========== SPACING ==========
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // ========== BORDER RADIUS ==========
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  static const double radiusFull = 999.0;

  // ========== ELEVATION ==========
  static List<BoxShadow> get elevation1 => [
        BoxShadow(
          color: const Color(0x0D000000),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevation2 => [
        BoxShadow(
          color: const Color(0x1A000000),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevation3 => [
        BoxShadow(
          color: const Color(0x26000000),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevation4 => [
        BoxShadow(
          color: const Color(0x33000000),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  // ========== ANIMATION DURATIONS ==========
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ========== THEME DATA ==========
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryMain,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondaryMain,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiaryMain,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onPrimary,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),

      // Typography
      textTheme: _textTheme,

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        titleTextStyle: _textTheme.titleLarge,
        toolbarHeight: 64,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: surfaceContainer,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMain,
          foregroundColor: onPrimary,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(0, 48),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMain,
          side: const BorderSide(color: primaryMain, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(0, 48),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMain,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          minimumSize: const Size(0, 40),
          textStyle: _textTheme.labelMedium,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryMain,
        foregroundColor: onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryMain, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: onSurfaceVariant.withValues(alpha: 0.6)),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: primaryContainer,
        labelStyle: _textTheme.labelMedium?.copyWith(color: onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainer,
        selectedItemColor: primaryMain,
        unselectedItemColor: onSurfaceVariant,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 4,
        backgroundColor: surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: _textTheme.headlineSmall,
        contentTextStyle: _textTheme.bodyMedium,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: onSurface,
        size: 24,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 40,
      ),

      // Scaffold
      scaffoldBackgroundColor: surface,

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onSurface,
        contentTextStyle: _textTheme.bodyMedium?.copyWith(color: surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 3,
      ),
    );
  }

  // ========== DARK THEME COLORS ==========
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainerHighest = Color(0xFF2C2C2C);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkOnSurfaceVariant = Color(0xFFCAC4D0);
  static const Color darkOutline = Color(0xFF3C3C3C);
  static const Color darkOutlineVariant = Color(0xFF2C2C2C);
  static const Color darkPrimaryMain = Color(0xFF6ECF8E);
  static const Color darkOnPrimary = Color(0xFF003919);
  static const Color darkPrimaryContainer = Color(0xFF1A5C30);
  static const Color darkOnPrimaryContainer = Color(0xFFA8F5BA);
  static const Color darkSecondaryMain = Color(0xFFD7C4B8);
  static const Color darkOnSecondary = Color(0xFF3B2D22);
  static const Color darkSecondaryContainer = Color(0xFF4E3E32);
  static const Color darkOnSecondaryContainer = Color(0xFFF5E8DC);
  static const Color darkTertiaryMain = Color(0xFF80D8FF);
  static const Color darkOnTertiary = Color(0xFF003549);
  static const Color darkTertiaryContainer = Color(0xFF004D66);
  static const Color darkOnTertiaryContainer = Color(0xFFB8EAFF);

  // ========== DARK THEME DATA ==========
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: darkPrimaryMain,
        onPrimary: darkOnPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        secondary: darkSecondaryMain,
        onSecondary: darkOnSecondary,
        secondaryContainer: darkSecondaryContainer,
        onSecondaryContainer: darkOnSecondaryContainer,
        tertiary: darkTertiaryMain,
        onTertiary: darkOnTertiary,
        tertiaryContainer: darkTertiaryContainer,
        onTertiaryContainer: darkOnTertiaryContainer,
        error: error,
        onError: onPrimary,
        surface: darkSurface,
        onSurface: darkOnSurface,
        surfaceContainerHighest: darkSurfaceContainerHighest,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkOutline,
        outlineVariant: darkOutlineVariant,
      ),

      // Typography
      textTheme: _darkTextTheme,

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: darkOnSurface,
        titleTextStyle: _darkTextTheme.titleLarge,
        toolbarHeight: 64,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: darkSurfaceContainer,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryMain,
          foregroundColor: darkOnPrimary,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(0, 48),
          textStyle: _darkTextTheme.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryMain,
          side: const BorderSide(color: darkPrimaryMain, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(0, 48),
          textStyle: _darkTextTheme.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryMain,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          minimumSize: const Size(0, 40),
          textStyle: _darkTextTheme.labelMedium,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimaryMain,
        foregroundColor: darkOnPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: darkPrimaryMain, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: darkOnSurfaceVariant.withValues(alpha: 0.6)),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: darkPrimaryContainer,
        labelStyle: _darkTextTheme.labelMedium?.copyWith(color: darkOnPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceContainer,
        selectedItemColor: darkPrimaryMain,
        unselectedItemColor: darkOnSurfaceVariant,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 4,
        backgroundColor: darkSurfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: _darkTextTheme.headlineSmall,
        contentTextStyle: _darkTextTheme.bodyMedium,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: darkOutline,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: darkOnSurface,
        size: 24,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 40,
      ),

      // Scaffold
      scaffoldBackgroundColor: darkSurface,

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkOnSurface,
        contentTextStyle: _darkTextTheme.bodyMedium?.copyWith(color: darkSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 3,
      ),
    );
  }

  // Text Theme
  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        height: 1.14,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        height: 1.16,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.22,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.29,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.27,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    );
  }

  // Dark Text Theme
  static TextTheme get _darkTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        height: 1.14,
        fontWeight: FontWeight.w700,
        color: darkOnSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        height: 1.16,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.22,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.29,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.27,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: darkOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w400,
        color: darkOnSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w400,
        color: darkOnSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
    );
  }

  // Helper method to create custom card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    List<BoxShadow>? shadows,
    double? radius,
  }) {
    return BoxDecoration(
      color: color ?? surfaceContainer,
      borderRadius: BorderRadius.circular(radius ?? radiusMedium),
      boxShadow: shadows ?? elevation2,
    );
  }

  // Helper method for gradient overlays on images
  static LinearGradient imageOverlayGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.7),
      ],
      stops: const [0.3, 1.0],
    );
  }
}
