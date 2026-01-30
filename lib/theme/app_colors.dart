import 'package:flutter/material.dart';

/// App color palette inspired by warm coffee shop aesthetic
/// 
/// Colors are carefully chosen for:
/// - Calm, soothing user experience
/// - High accessibility (WCAG AA compliance)
/// - Warm, inviting atmosphere
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============= PRIMARY COLORS =============
  
  /// Warm brown background - coffee shop ambiance
  static const Color backgroundDark = Color(0xFF4A3933);
  
  /// Main background color
  static const Color background = Color(0xFF4A3933);
  
  /// Lighter brown for cards and elevated surfaces
  static const Color surfaceWarm = Color(0xFF6B5347);
  
  /// Cream/beige for light backgrounds
  static const Color cream = Color(0xFFF5E6D3);
  
  /// Soft cream for subtle backgrounds
  static const Color creamLight = Color(0xFFFAF3E8);

  // ============= ACCENT COLORS =============
  
  /// Soft green for primary actions (Continue button)
  static const Color primaryGreen = Color(0xFF7CAF6E);
  
  /// Darker green for pressed state
  static const Color primaryGreenDark = Color(0xFF5A8E4D);
  
  /// Lighter green for hover/disabled states
  static const Color primaryGreenLight = Color(0xFF9BC68E);

  // ============= SECONDARY COLORS =============
  
  /// Muted purple/blue for secondary buttons
  static const Color secondaryPurple = Color(0xFF8E9AAF);
  
  /// Darker purple for pressed state
  static const Color secondaryPurpleDark = Color(0xFF6B7590);
  
  /// Lighter purple for hover state
  static const Color secondaryPurpleLight = Color(0xFFABB5C9);

  // ============= TEXT COLORS =============
  
  /// White/cream text for dark backgrounds
  static const Color textLight = Color(0xFFFBFBFB);
  
  /// Darker text for light backgrounds
  static const Color textDark = Color(0xFF2C2420);
  
  /// Muted text for helper/secondary content
  static const Color textMuted = Color(0xFFB8ACA3);
  
  /// Disabled text
  static const Color textDisabled = Color(0xFF8B7F76);

  // ============= EMOTION BUTTON COLORS =============
  
  /// Anxious - soft coral/pink
  static const Color emotionAnxious = Color(0xFFEFAA9D);
  
  /// Overwhelmed - soft blue
  static const Color emotionOverwhelmed = Color(0xFF9DBBEF);
  
  /// Sad - light yellow/gold
  static const Color emotionSad = Color(0xFFEFD89D);
  
  /// Angry - soft red
  static const Color emotionAngry = Color(0xFFEF9D9D);
  
  /// Numb - neutral gray
  static const Color emotionNumb = Color(0xFFCDC3BB);
  
  /// Not Sure - light purple
  static const Color emotionNotSure = Color(0xFFB8ACEF);

  // ============= CRISIS & ALERT COLORS =============
  
  /// Crisis red - for 911/988 buttons
  static const Color crisisRed = Color(0xFFD94848);
  
  /// Warning orange
  static const Color warningOrange = Color(0xFFE89A3C);
  
  /// Info blue
  static const Color infoBlue = Color(0xFF5B9BD5);

  // ============= UI ELEMENT COLORS =============
  
  /// Border color for cards and inputs
  static const Color border = Color(0xFF9B887A);
  
  /// Divider color
  static const Color divider = Color(0xFF7A6B5E);
  
  /// Shadow color
  static const Color shadow = Color(0x40000000);

  // ============= EMOTION BUTTON COLORS =============
  // Specific gradients/backgrounds matching the reference image
  static const Color emotionAnxiousBg = Color(0xFFFBE4D5); // Light beige/peach
  static const Color emotionAnxiousIcon = Color(0xFFE85D45); // Red/Orange
  
  static const Color emotionOverwhelmedBg = Color(0xFFEAE2D6); // Light beige
  static const Color emotionOverwhelmedIcon = Color(0xFF5B6E8C); // Slate blue
  
  static const Color emotionSadBg = Color(0xFFFBEBC6); // Light yellow/beige
  static const Color emotionSadIcon = Color(0xFFFDD835); // Yellow
  
  static const Color emotionAngryBg = Color(0xFFF5C2B6); // Light reddish/pink
  static const Color emotionAngryIcon = Color(0xFFD32F2F); // Red
  
  static const Color emotionNumbBg = Color(0xFFEEE5D3); // Light tan
  static const Color emotionNumbIcon = Color(0xFFFBC02D); // Yellow neutral
  
  static const Color emotionNotSureBg = Color(0xFFD6CEDE); // Light purple/grey
  static const Color emotionNotSureIcon = Color(0xFF5E6F9F); // Blue/Purple
  
  // Bottom buttons
  static const Color helpOptionsBg = Color(0xFFC78D87); // Muted vintage pink
  static const Color helpOptionsText = Colors.white;
  
  static const Color continueGreenStart = Color(0xFF6AB04C); // Gradient start
  static const Color continueGreenEnd = Color(0xFF529438);   // Gradient end

  // Glassmorphism
  static const Color glassSurface = Color(0x33000000); // Darker semi-transparent
  static const Color glassBorder = Color(0x1FFFFFFF);
  
  /// Overlay/scrim for modals
  static const Color scrim = Color(0x80000000);

  // ============= HELPER METHODS =============
  
  /// Get emotion color by type
  static Color getEmotionColor(String emotionType) {
    switch (emotionType.toLowerCase()) {
      case 'panic':
      case 'anxiety':
      case 'anxious':
        return emotionAnxious;
      case 'overwhelmed':
        return emotionOverwhelmed;
      case 'sad':
        return emotionSad;
      case 'angry':
        return emotionAngry;
      case 'numb':
        return emotionNumb;
      case 'not sure':
      case 'notsure':
        return emotionNotSure;
      default:
        return surfaceWarm;
    }
  }
}
