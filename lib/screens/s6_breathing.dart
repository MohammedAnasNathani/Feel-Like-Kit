import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/timer_widget.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/eli_guide_bubble.dart';

/// S6: Breathing Screen
/// 
/// Title: "Let's slow your breath"
/// 
/// Features:
/// - Breathing style selector (per Figma spec)
/// - Text guidance for breathing
/// - 60-second timer
/// - Info tooltip
/// - Start/Pause, Skip, Continue controls
/// - Navigation: → S7 (Grounding)
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool _timerCompleted = false;
  String? _selectedStyle;
  bool _showTimer = false;

  final List<Map<String, String>> _breathingStyles = [
    {
      'id': 'slow_exhale',
      'title': 'Slow exhale',
      'instruction': 'Breathe in through your nose.\nBreathe out slowly, longer than you breathe in.',
    },
    {
      'id': 'box',
      'title': 'Box breathing (4-4-4-4)',
      'instruction': 'In for 4... Hold for 4...\nOut for 4... Hold for 4...',
    },
    {
      'id': 'natural',
      'title': 'Just breathe naturally',
      'instruction': 'No pattern needed.\nJust notice your breath.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        child: _showTimer ? _buildTimerView() : _buildStyleSelector(),
      ),
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: AppTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Let\'s slow your breath',
                  style: AppTypography.heading1,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Choose a breathing style',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Breathing style options
                ..._breathingStyles.map((style) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChoiceCard(
                      text: style['title']!,
                      isSelected: _selectedStyle == style['id'],
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedStyle = style['id'];
                        });
                      },
                    ),
                  );
                }),
                
                const SizedBox(height: 8),
                
                // Info tooltip
                InfoTooltip(
                  text: 'Longer exhales activate your body\'s calming system.',
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        
        // Fixed bottom buttons
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Skip',
                  onPressed: _handleContinue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Start',
                  onPressed: _selectedStyle != null ? _startTimer : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerView() {
    final selectedStyle = _breathingStyles.firstWhere(
      (s) => s['id'] == _selectedStyle,
      orElse: () => _breathingStyles[0],
    );
    
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: AppTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Let\'s slow your breath',
                  style: AppTypography.heading1,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),

                // Eli Guide
                const EliGuideBubble(screenId: 's6_breathing'),

                const SizedBox(height: 16),
                
                // Style chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.air,
                        size: 18,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedStyle['title']!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Instruction card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    selectedStyle['instruction']!,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 20,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Timer
                TimerWidget(
                  durationSeconds: 60,
                  onComplete: () {
                    setState(() {
                      _timerCompleted = true;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Completion indicator
                if (_timerCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Great work!',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Info tooltip
                InfoTooltip(
                  text: 'Longer exhales activate your body\'s calming system.',
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        
        // Fixed bottom buttons
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Skip',
                  onPressed: _handleContinue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: _handleContinue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    setState(() {
      _showTimer = true;
    });
  }

  void _handleContinue() {
    // Mark breathing as completed
    context.read<SessionProvider>().markBreathingCompleted();
    
    // Navigate to Grounding (S7)
    Navigator.of(context).pushNamed('/grounding');
  }
}
