import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../models/intensity.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S2: Intensity Selection Screen
/// 
/// Prompt: "How strong does it feel?"
/// 
/// Features:
/// - 4 intensity levels
/// - Conditional routing based on feeling + intensity
/// - If (Panic/Anxiety or Numb) AND High → Safety Check (S3)
/// - Otherwise → Tool Selection (S4)
class IntensityScreen extends StatefulWidget {
  const IntensityScreen({super.key});

  @override
  State<IntensityScreen> createState() => _IntensityScreenState();
}

class _IntensityScreenState extends State<IntensityScreen> {
  Intensity? _selectedIntensity;

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
              const SizedBox(height: 24),
              
              // Main prompt
              Text(
                'How strong does it feel?',
                style: AppTypography.heading1,
              ),
              
              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's2_intensity'),
              
              const SizedBox(height: 16),
              
              // Intensity options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: Intensity.values.map((intensity) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChoiceCard(
                        text: intensity.displayName,
                        isSelected: _selectedIntensity == intensity,
                        onTap: () {
                          setState(() {
                            _selectedIntensity = intensity;
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
                      text: 'Back',
                      onPressed: () => Navigator.pop(context),
                      // Icon removed to prevent text truncation on small screens
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: _selectedIntensity != null ? _handleContinue : null,
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
    if (_selectedIntensity == null) return;
    
    final sessionProvider = context.read<SessionProvider>();
    
    // Save intensity to session
    sessionProvider.setIntensity(_selectedIntensity!);
    
    // Conditional routing:
    // If (Panic/Anxiety or Numb) AND High → Safety Check (S3)
    // Otherwise → Tool Selection (S4)
    if (sessionProvider.shouldShowSafetyCheck) {
      Navigator.of(context).pushNamed('/safety-check');
    } else {
      Navigator.of(context).pushNamed('/tool-selection');
    }
  }
}
