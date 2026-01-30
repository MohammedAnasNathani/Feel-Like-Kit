import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/timer_widget.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S9: Movement Screen
/// 
/// Title: "Let's reset your body"
/// 
/// Features:
/// - 2 options: Gentle movement / Fast movement
/// - Skip option
/// - Timer with instructions based on selection
/// - Info tooltip
/// - Both paths → S13 (Sustain Calm)
class MovementScreen extends StatefulWidget {
  const MovementScreen({super.key});

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  String? _selectedType; // 'gentle', 'fast', or null
  bool _showTimer = false;
  bool _timerCompleted = false;

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
        child: _showTimer ? _buildTimerView() : _buildSelectionView(),
      ),
    );
  }

  Widget _buildSelectionView() {
    return Padding(
      padding: AppTheme.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          Text(
            'Let\'s reset your body',
            style: AppTypography.heading1,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),

          // Eli Guide
          const EliGuideBubble(screenId: 's9_movement'),
          
          const SizedBox(height: 16),
          
          Text(
            'Choose a movement style',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),

          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ChoiceCard(
                  text: 'Gentle movement',
                  subtitle: 'Roll shoulders, loosen jaw, stretch',
                  icon: Icons.self_improvement,
                  isSelected: _selectedType == 'gentle',
                  onTap: () {
                    setState(() {
                      _selectedType = 'gentle';
                    });
                  },
                ),
                const SizedBox(height: 12),
                ChoiceCard(
                  text: 'Fast movement',
                  subtitle: 'Steps in place, wall pushes, shake it out',
                  icon: Icons.directions_run,
                  isSelected: _selectedType == 'fast',
                  onTap: () {
                    setState(() {
                      _selectedType = 'fast';
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Info tooltip
                InfoTooltip(
                  text: 'Movement helps release stuck stress energy from your body.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bottom buttons
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
                  text: 'Start',
                  onPressed: _selectedType != null ? _handleStart : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerView() {
    final isGentle = _selectedType == 'gentle';
    final duration = isGentle ? 45 : 30;

    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            padding: AppTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  'Let\'s reset your body',
                  style: AppTypography.heading1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Eli Guide
                const EliGuideBubble(screenId: 's9_movement'),
                
                const SizedBox(height: 16),

                // Movement type chip
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
                        isGentle ? Icons.self_improvement : Icons.directions_run,
                        size: 18,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isGentle ? 'Gentle movement' : 'Fast movement',
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
                  child: Column(
                    children: isGentle
                        ? [
                            _buildInstructionItem('🙆', 'Roll your shoulders slowly'),
                            const SizedBox(height: 16),
                            _buildInstructionItem('😌', 'Loosen your jaw'),
                            const SizedBox(height: 16),
                            _buildInstructionItem('🧘', 'Stretch your neck gently'),
                          ]
                        : [
                            _buildInstructionItem('🏃', 'Fast steps in place'),
                            const SizedBox(height: 16),
                            _buildInstructionItem('💪', 'Wall push-ups'),
                            const SizedBox(height: 16),
                            _buildInstructionItem('🤸', 'Shake out your hands'),
                          ],
                  ),
                ),

                const SizedBox(height: 32),

                // Timer
                TimerWidget(
                  durationSeconds: duration,
                  onComplete: () {
                    setState(() {
                      _timerCompleted = true;
                    });
                  },
                ),

                const SizedBox(height: 16),

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
                          'Great work! Your body thanks you.',
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
                  text: 'Movement helps release stuck stress energy from your body.',
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Fixed bottom buttons - OUTSIDE scrollable area
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
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

  Widget _buildInstructionItem(String emoji, String text) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyLarge.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _handleStart() {
    if (_selectedType == null) return;

    // Save movement type
    context.read<SessionProvider>().setMovementType(_selectedType!);

    setState(() {
      _showTimer = true;
    });
  }

  void _handleSkip() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }

  void _handleContinue() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }
}
