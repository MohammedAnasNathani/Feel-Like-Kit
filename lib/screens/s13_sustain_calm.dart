import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S13: Sustain the Calm Screen
/// 
/// Title: "Help this calm last"
/// 
/// Features:
/// - Show 4 options from rotation pool of 6
/// - Selection shows one-line instruction
/// - Info tooltip
/// - Navigation: → S14 (Reflect & Prepare)
class SustainCalmScreen extends StatefulWidget {
  const SustainCalmScreen({super.key});

  @override
  State<SustainCalmScreen> createState() => _SustainCalmScreenState();
}

class _SustainCalmScreenState extends State<SustainCalmScreen> {
  String? _selectedAction;
  late List<_SustainOption> _displayedOptions;

  final List<_SustainOption> _allOptions = [
    _SustainOption(
      id: 'drink_water',
      title: 'Drink water',
      instruction: 'Take a few sips.',
      icon: Icons.water_drop,
    ),
    _SustainOption(
      id: 'change_posture',
      title: 'Change posture',
      instruction: 'Drop shoulders. Unclench jaw.',
      icon: Icons.accessibility_new,
    ),
    _SustainOption(
      id: 'keep_using',
      title: 'Keep using this item',
      instruction: 'Keep using your item for 30 seconds.',
      icon: Icons.replay,
    ),
    _SustainOption(
      id: 'slow_down',
      title: 'Slow down for 1 minute',
      instruction: 'Move slower for one minute.',
      icon: Icons.slow_motion_video,
    ),
    _SustainOption(
      id: 'step_outside',
      title: 'Step outside',
      instruction: 'If you can, take one breath of fresh air.',
      icon: Icons.park,
    ),
    _SustainOption(
      id: 'decide_later',
      title: 'I don\'t need to decide anything right now',
      instruction: 'Tell yourself: "This can wait."',
      icon: Icons.pause_circle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectOptions();
  }

  void _selectOptions() {
    // Shuffle and take 4 options per spec
    // Ensure at least 1 physical (water/posture) and 1 pacing/decision option
    final physical = [_allOptions[0], _allOptions[1]]; // water, posture
    final pacing = [_allOptions[3], _allOptions[5]]; // slow down, decide later
    final other = [_allOptions[2], _allOptions[4]]; // keep using, step outside

    final selected = <_SustainOption>[];

    // Take 1 random physical
    physical.shuffle(Random());
    selected.add(physical.first);

    // Take 1 random pacing
    pacing.shuffle(Random());
    selected.add(pacing.first);

    // Take 2 random from remaining
    final remaining = [...physical.skip(1), ...pacing.skip(1), ...other];
    remaining.shuffle(Random());
    selected.addAll(remaining.take(2));

    selected.shuffle(Random());

    setState(() {
      _displayedOptions = selected;
    });
  }

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
                'Help this calm last',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's13_sustain_calm'),

              const SizedBox(height: 24),

              // Sustain options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ..._displayedOptions.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChoiceCard(
                          text: option.title,
                          subtitle: _selectedAction == option.id ? option.instruction : null,
                          icon: option.icon,
                          isSelected: _selectedAction == option.id,
                          onTap: () {
                            setState(() {
                              _selectedAction = option.id;
                            });
                          },
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Info tooltip
                    InfoTooltip(
                      text: 'Small follow-ups prevent stress rebound.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom buttons - Added Skip per spec
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
                      onPressed: _selectedAction != null ? _handleContinue : null,
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

  void _handleSkip() {
    // Skip sustain options, go to S14
    Navigator.of(context).pushNamed('/reflect-prepare');
  }

  void _handleContinue() {
    if (_selectedAction == null) return;

    // Save sustain action
    context.read<SessionProvider>().setSustainAction(_selectedAction!);

    // Navigate to Reflect & Prepare (S14)
    Navigator.of(context).pushNamed('/reflect-prepare');
  }
}

class _SustainOption {
  final String id;
  final String title;
  final String instruction;
  final IconData icon;

  _SustainOption({
    required this.id,
    required this.title,
    required this.instruction,
    required this.icon,
  });
}
