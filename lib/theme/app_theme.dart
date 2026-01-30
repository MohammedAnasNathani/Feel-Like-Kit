import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Main theme configuration for Feel Like Kit
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Main theme data
  static ThemeData get theme => ThemeData(
    // ============= COLOR SCHEME =============
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.textLight,
      secondary: AppColors.secondaryPurple,
      onSecondary: AppColors.textLight,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textLight,
      error: AppColors.crisisRed,
      onError: AppColors.textLight,
    ),

    // ============= SCAFFOLD =============
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // ============= APP BAR =============
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textLight,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.appTitle,
    ),

    // ============= TEXT THEME =============
    textTheme: TextTheme(
      displayLarge: AppTypography.heading1,
      displayMedium: AppTypography.heading2,
      displaySmall: AppTypography.heading3,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.buttonPrimary,
    ),

    // ============= ELEVATED BUTTON (Primary Actions) =============
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textLight,
        disabledBackgroundColor: AppColors.primaryGreenLight.withOpacity(0.5),
        disabledForegroundColor: AppColors.textDisabled,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: AppTypography.buttonPrimary,
      ),
    ),

    // ============= OUTLINED BUTTON (Secondary Actions) =============
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textLight,
        side: BorderSide(color: AppColors.secondaryPurple, width: 1.5),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: AppTypography.buttonSecondary,
      ),
    ),

    // ============= TEXT BUTTON (Tertiary Actions) =============
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.buttonSecondary,
      ),
    ),

    // ============= CARD =============
    cardTheme: CardThemeData(
      color: AppColors.surfaceWarm,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // ============= INPUT DECORATION =============
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceWarm,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: AppTypography.muted(AppTypography.bodyMedium),
    ),

    // ============= DIVIDER =============
    dividerTheme: DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 24,
    ),

    // ============= ICON THEME =============
    iconTheme: IconThemeData(
      color: AppColors.textLight,
      size: 24,
    ),

    // ============= CHECKBOX =============
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreen;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textLight),
      side: BorderSide(color: AppColors.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // ============= DIALOG =============
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceWarm,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      titleTextStyle: AppTypography.heading2,
      contentTextStyle: AppTypography.bodyMedium,
    ),

    // ============= BOTTOM SHEET =============
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ============= MISC =============
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    splashFactory: InkRipple.splashFactory,
  );

  // ============= CUSTOM PROPERTIES =============

  /// Border radius for cards and buttons
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusSmall = 8.0;

  /// Spacing constants
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  /// Screen padding (no scrolling in Calm Mode, fixed padding)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 24,
  );

  /// Minimum tap target size (accessibility requirement: 48px)
  static const double minTapTargetSize = 56.0;

  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
