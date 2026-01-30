import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../services/storage_service.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S14: Reflect & Prepare Screen
/// 
/// Title: "Want to make next time easier?"
/// 
/// Features:
/// - 4 options: Save what helped / Add to kit / Try different / Skip
/// - Static prep suggestions block
/// - Save selections to storage
/// - Navigation: → S15 (Completion)
class ReflectPrepareScreen extends StatefulWidget {
  const ReflectPrepareScreen({super.key});

  @override
  State<ReflectPrepareScreen> createState() => _ReflectPrepareScreenState();
}

class _ReflectPrepareScreenState extends State<ReflectPrepareScreen> {
  String? _selectedOption;

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
        child: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Title
              Text(
                'Want to make next time easier?',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's14_reflect_prepare'),

              const SizedBox(height: 24),

              // Options
              ChoiceCard(
                text: 'Save what helped',
                subtitle: 'Remember the tools that worked',
                icon: Icons.favorite,
                isSelected: _selectedOption == 'save_what_helped',
                onTap: () {
                  setState(() {
                    _selectedOption = 'save_what_helped';
                  });
                },
              ),
              const SizedBox(height: 12),

              ChoiceCard(
                text: 'Add item to my kit list',
                subtitle: 'Build your personal kit',
                icon: Icons.add_box,
                isSelected: _selectedOption == 'add_to_kit',
                onTap: () {
                  setState(() {
                    _selectedOption = 'add_to_kit';
                  });
                },
              ),
              const SizedBox(height: 12),

              ChoiceCard(
                text: 'Try something else next time',
                subtitle: 'Explore different options',
                icon: Icons.shuffle,
                isSelected: _selectedOption == 'try_different',
                onTap: () {
                  setState(() {
                    _selectedOption = 'try_different';
                  });
                },
              ),
              const SizedBox(height: 12),

              ChoiceCard(
                text: 'Skip',
                icon: Icons.skip_next,
                isSelected: _selectedOption == 'skip',
                onTap: () {
                  setState(() {
                    _selectedOption = 'skip';
                  });
                },
              ),

              const SizedBox(height: 32),

              // Static prep suggestions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Prep for next time',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSuggestion('Keep gum in your bag'),
                    const SizedBox(height: 8),
                    _buildSuggestion('Put headphones by the door'),
                    const SizedBox(height: 8),
                    _buildSuggestion('Write a grounding word for your bracelet'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Bottom button
              PrimaryButton(
                text: 'Continue',
                onPressed: _selectedOption != null ? _handleContinue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleContinue() async {
    if (_selectedOption == null) return;

    final sessionProvider = context.read<SessionProvider>();
    final storage = StorageService();

    // Handle selected option
    switch (_selectedOption) {
      case 'save_what_helped':
        // Save tool ID and add-on to "what helped"
        final toolId = sessionProvider.currentSession.toolId;
        if (toolId != null) {
          await storage.addToWhatHelped(toolId);
          sessionProvider.addSavedItem(toolId);
        }
        break;

      case 'add_to_kit':
        // Add current tool to kit list
        final toolId = sessionProvider.currentSession.toolId;
        if (toolId != null) {
          await storage.addToKitList(toolId);
        }
        break;

      case 'try_different':
        // Store preference to vary more (metadata for future sessions)
        // Can be used in rotation logic
        break;

      case 'skip':
        // No action needed
        break;
    }

    // Navigate to Completion (S15)
    if (mounted) {
      Navigator.of(context).pushNamed('/completion');
    }
  }
}
