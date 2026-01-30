import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Progress indicator dots showing current step in flow
/// 
/// Shows: ● ● ○ ○ ○ style indicator
/// Per Figma spec: "Progress dots (● ○ ○ ○)"
class ProgressDots extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  
  const ProgressDots({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        final isCurrent = index == currentStep;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive || isCurrent 
                ? AppColors.primaryGreen 
                : AppColors.border.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
