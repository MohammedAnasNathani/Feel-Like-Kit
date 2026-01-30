import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for Feel Like Kit
/// 
/// Uses:
/// - Outfit for headings (friendly, modern, slightly rounded)
/// - Inter for body text (highly readable, calm)
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // ============= HEADINGS =============
  
  /// Large heading - Screen titles
  /// Example: "How are you feeling right now?"
  static TextStyle get heading1 => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textLight,
  );
  
  /// Medium heading - Section titles
  /// Example: "Let's help your body first"
  static TextStyle get heading2 => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textLight,
  );
  
  /// Small heading - Subsections
  /// Example: "My Kit", "Nearby"
  static TextStyle get heading3 => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textLight,
  );

  // ============= BODY TEXT =============
  
  /// Regular body text
  /// Example: Instructions, descriptions
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textLight,
  );
  
  /// Medium body text
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textLight,
  );
  
  /// Small body text - Helper text
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  // ============= BUTTONS =============
  
  /// Primary button text
  static TextStyle get buttonPrimary => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
    color: AppColors.textLight,
  );
  
  /// Secondary button text
  static TextStyle get buttonSecondary => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textLight,
  );
  
  /// Emotion button text
  static TextStyle get buttonEmotion => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textDark,
  );

  // ============= SPECIAL TEXT =============
  
  /// App title/logo
  /// Example: "Feel Like 💩 Kit"
  static TextStyle get appTitle => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textLight,
  );
  
  /// Subtitle/mode indicator
  /// Example: "Calm Mode"
  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.textMuted,
  );
  
  /// Eli's speech/messages
  static TextStyle get eliMessage => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    fontStyle: FontStyle.italic,
    color: AppColors.textLight,
  );
  
  /// Info tooltip text
  static TextStyle get tooltip => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );
  
  /// Timer display
  static TextStyle get timer => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textLight,
  );

  // ============= HELPER METHODS =============
  
  /// Create a text style variant with different color
  static TextStyle withColor(TextStyle base, Color color) {
    return base.copyWith(color: color);
  }
  
  /// Create a dark variant (for light backgrounds)
  static TextStyle dark(TextStyle base) {
    return base.copyWith(color: AppColors.textDark);
  }
  
  /// Create a muted variant
  static TextStyle muted(TextStyle base) {
    return base.copyWith(color: AppColors.textMuted);
  }
}
