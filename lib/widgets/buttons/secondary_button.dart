import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Secondary action button (Skip, Back, Help Options, etc.)
/// 
/// Features:
/// - Outlined style (muted appearance)
/// - Minimum height 56px
/// - Full-width by default
/// - Visually distinct from primary actions
/// - Haptic feedback
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final Color? textColor;
  final Color? borderColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed == null ? null : () {
          HapticFeedback.selectionClick();
          onPressed!();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.textMuted,
          side: BorderSide(
            color: borderColor ?? AppColors.secondaryPurple.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                text,
                style: AppTypography.buttonSecondary.copyWith(
                  color: textColor ?? AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
