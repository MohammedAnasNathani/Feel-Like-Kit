import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S11: Thought Check Screen (CBT/DBT-lite)
/// 
/// Title: "Check the thought (optional)"
/// 
/// Features:
/// - Prompt: "What's the main thought looping?"
/// - 5 common thoughts + Skip
/// - Selection → S11b Quick Challenge
/// - Skip → S13 (Sustain Calm)
class ThoughtCheckScreen extends StatefulWidget {
  const ThoughtCheckScreen({super.key});

  @override
  State<ThoughtCheckScreen> createState() => _ThoughtCheckScreenState();
}

class _ThoughtCheckScreenState extends State<ThoughtCheckScreen> {
  String? _selectedThought;

  final List<Map<String, String>> _thoughts = [
    {
      'id': 'something_bad_will_happen',
      'text': 'Something bad will happen',
    },
    {
      'id': 'alone_no_one_cares',
      'text': 'I\'m alone / no one cares',
    },
    {
      'id': 'feeling_wont_end',
      'text': 'This feeling won\'t end',
    },
    {
      'id': 'messed_everything_up',
      'text': 'I messed everything up',
    },
    {
      'id': 'something_else',
      'text': 'Something else',
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
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Title
              Text(
                'Check the thought',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 8),

              Text(
                '(optional)',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's11_thought_check'),

              const SizedBox(height: 16),

              // Prompt
              Text(
                'What\'s the main thought looping?',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // Thought options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _thoughts.map((thought) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChoiceCard(
                        text: thought['text']!,
                        isSelected: _selectedThought == thought['id'],
                        onTap: () {
                          setState(() {
                            _selectedThought = thought['id'];
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
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
                      onPressed: _selectedThought != null ? _handleContinue : null,
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

  void _handleContinue() {
    if (_selectedThought == null) return;

    // Save thought category
    context.read<SessionProvider>().setThoughtCategory(_selectedThought!);

    // Navigate to Quick Challenge (S11b)
    Navigator.of(context).pushNamed('/quick-challenge');
  }

  void _handleSkip() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }
}
