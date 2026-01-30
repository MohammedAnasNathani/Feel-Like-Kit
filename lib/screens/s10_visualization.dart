import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';

/// S10: Visualization (Happy Place) Screen
/// 
/// Title: "Go to a calm place"
/// 
/// Features:
/// - Sequential prompts (tap Continue to advance)
/// - 4 sensory prompts
/// - "Stay a bit longer" option (cycles prompts)
/// - Skip option
/// - Navigation: → S13 (Sustain Calm)
class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({super.key});

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  int _currentPromptIndex = 0;

  final List<String> _prompts = [
    'Picture a place where you feel safe or okay.',
    'What do you see there?',
    'What do you hear?',
    'What do you feel on your skin?',
    'Any smell or temperature?',
  ];

  @override
  Widget build(BuildContext context) {
    final isLastPrompt = _currentPromptIndex >= _prompts.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feel Like 💩 Kit',
          style: AppTypography.appTitle.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Title
              Text(
                'Go to a calm place',
                style: AppTypography.heading1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_prompts.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= _currentPromptIndex
                          ? AppColors.primaryGreen
                          : AppColors.surfaceWarm,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 48),

              // Current prompt
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          _prompts[_currentPromptIndex],
                          style: AppTypography.heading2.copyWith(
                            fontSize: 22,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Gentle reminder
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Take your time. Let the image form.',
                          style: AppTypography.bodySmall.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Info tooltip
                      InfoTooltip(
                        text: 'Imagery activates calming brain networks.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom buttons
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Skip',
                          onPressed: _handleSkip,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          text: isLastPrompt ? 'Complete' : 'Continue',
                          onPressed: _handleContinue,
                        ),
                      ),
                    ],
                  ),

                  if (!isLastPrompt) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _stayLonger,
                      child: Text(
                        'Stay a bit longer with this prompt',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_currentPromptIndex < _prompts.length - 1) {
      // Go to next prompt
      setState(() {
        _currentPromptIndex++;
      });
    } else {
      // Last prompt, navigate to Sustain Calm
      Navigator.of(context).pushNamed('/sustain-calm');
    }
  }

  void _stayLonger() {
    // Just keep on current prompt (no action needed)
    // User can continue when ready
  }

  void _handleSkip() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }
}
