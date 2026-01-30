import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S11b: Quick Challenge Screen (ONE STEP ONLY)
/// 
/// Title: "Let's test it gently"
/// 
/// Features:
/// - 3 challenge questions
/// - Optional: balanced thought choices after selection
/// - Info tooltip
/// - Navigation: → S13 (Sustain Calm)
class QuickChallengeScreen extends StatefulWidget {
  const QuickChallengeScreen({super.key});

  @override
  State<QuickChallengeScreen> createState() => _QuickChallengeScreenState();
}

class _QuickChallengeScreenState extends State<QuickChallengeScreen> {
  String? _selectedChallenge;
  String? _selectedBalancedThought;
  bool _showBalancedThoughts = false;

  final List<Map<String, String>> _challenges = [
    {
      'id': 'feeling_or_fact',
      'text': 'Is this a feeling or a fact?',
    },
    {
      'id': 'tell_friend',
      'text': 'What would I tell a friend right now?',
    },
    {
      'id': 'wait_later',
      'text': 'Can this wait until later?',
    },
  ];

  final List<String> _balancedThoughts = [
    'This is uncomfortable, not dangerous.',
    'Feelings pass, even when they feel permanent.',
    'I don\'t have to solve everything right now.',
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
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Title
              Text(
                'Let\'s test it gently',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's11b_quick_challenge'),

              const SizedBox(height: 16),

              // View switches based on selection
              Expanded(
                child: !_showBalancedThoughts
                    ? _buildChallengeView()
                    : _buildBalancedThoughtView(),
              ),

              const SizedBox(height: 24),

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
                      text: 'Continue',
                      onPressed: _selectedChallenge != null || _selectedBalancedThought != null
                          ? _handleContinue
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeView() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          'Choose a question to ask yourself:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 20),

        ..._challenges.map((challenge) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChoiceCard(
              text: challenge['text']!,
              isSelected: _selectedChallenge == challenge['id'],
              onTap: () {
                setState(() {
                  _selectedChallenge = challenge['id'];
                  _showBalancedThoughts = true;
                });

                // Save challenge question
                context.read<SessionProvider>().setChallengeQuestion(challenge['text']!);
              },
            ),
          );
        }).toList(),

        const SizedBox(height: 24),

        InfoTooltip(
          text: 'Questioning thoughts lowers emotional intensity.',
        ),
      ],
    );
  }

  Widget _buildBalancedThoughtView() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          'Choose a balanced thought:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 20),

        ..._balancedThoughts.map((thought) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChoiceCard(
              text: thought,
              isSelected: _selectedBalancedThought == thought,
              onTap: () {
                setState(() {
                  _selectedBalancedThought = thought;
                });
              },
            ),
          );
        }).toList(),

        const SizedBox(height: 16),

        // Option to go back
        TextButton(
          onPressed: () {
            setState(() {
              _showBalancedThoughts = false;
              _selectedBalancedThought = null;
            });
          },
          child: Text(
            'Choose a different question',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }

  void _handleSkip() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }
}
