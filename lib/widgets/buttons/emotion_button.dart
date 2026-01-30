import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/feeling.dart';

/// Emotion button for feeling selection
/// 
/// Features:
/// - Colorful background per emotion
/// - Emoji icons
/// - Selected state with border
/// - Haptic feedback
class EmotionButton extends StatelessWidget {
  final Feeling feeling;
  final bool isSelected;
  final VoidCallback onTap;

  const EmotionButton({
    super.key,
    required this.feeling,
    required this.isSelected,
    required this.onTap,
  });

  // Background colors exactly matching the reference
  Color _getBackgroundColor(Feeling feeling) {
    switch (feeling) {
      case Feeling.panicAnxiety:
        return const Color(0xFFFDF6F0); // Very light cream/peach
      case Feeling.overwhelmed:
        return const Color(0xFFF0F2F4); // Light grey-blue
      case Feeling.sad:
        return const Color(0xFFFFF9E0); // Light warm yellow
      case Feeling.angry:
        return const Color(0xFFFCE4E1); // Light pink/salmon
      case Feeling.numb:
        return const Color(0xFFFFF8E1); // Light yellow/cream
      case Feeling.notSure:
        return const Color(0xFFEDE7F6); // Light lavender
    }
  }

  // Emoji icons matching the reference exactly
  String _getEmoji(Feeling feeling) {
    switch (feeling) {
      case Feeling.panicAnxiety:
        return '😰'; // Anxious face with sweat
      case Feeling.overwhelmed:
        return '📚'; // Stack of books
      case Feeling.sad:
        return '😢'; // Crying face
      case Feeling.angry:
        return '😠'; // Angry face
      case Feeling.numb:
        return '😐'; // Neutral face
      case Feeling.notSure:
        return '❓'; // Question mark
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(feeling);
    final emoji = _getEmoji(feeling);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 56), // Minimum height, but flexible
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5E3C) : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji container (left side)
            Container(
              width: 56,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: feeling == Feeling.notSure
                  ? Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7986CB), // Blue-purple for ?
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
            ),
            // Label text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    feeling.displayName,
                    style: AppTypography.bodyLarge.copyWith(
                      color: const Color(0xFF3D3D3D),
                      fontWeight: FontWeight.w600,
                      fontSize: 17, // Started slightly larger, will scale down if needed
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
