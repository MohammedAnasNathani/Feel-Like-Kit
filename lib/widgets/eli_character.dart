import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Eli character widget
/// 
/// Displays the static Eli character image with optional speech bubble
/// Used on: Home (S1), Use Tool (S5), Completion (S15)
class EliCharacter extends StatelessWidget {
  final String? message;
  final double size;
  final bool showSpeechBubble;

  const EliCharacter({
    super.key,
    this.message,
    this.size = 200,
    this.showSpeechBubble = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble (if message provided)
        if (message != null && showSpeechBubble) ...[
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              message!,
              style: AppTypography.eliMessage,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Eli character image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/eli_character.jpg',
            height: size,
            width: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image not found
              return Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: size * 0.4,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Eli',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
