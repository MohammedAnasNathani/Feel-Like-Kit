import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../services/storage_service.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S7: Grounding / Noticing Screen
/// 
/// Title: "Ground in the present"
/// 
/// Features:
/// - 1-2 prompts from rotation pool (5 total)
/// - Rotation logic: avoid last 2 used
/// - Info tooltip
/// - Continue | Skip buttons
/// - Navigation: → S8 (Add-On Selector)
class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  final List<String> _allPrompts = [
    'Name 3 things you can see.',
    'Notice 2 things you can feel with your body.',
    'Name 1 sound you hear.',
    'Notice your feet touching the floor.',
    'Notice the temperature around you.',
  ];

  late List<String> _selectedPrompts;

  @override
  void initState() {
    super.initState();
    _selectPrompts();
  }

  void _selectPrompts() {
    final storage = StorageService();
    final lastUsedIndices = storage.lastGroundingPrompts;
    
    // Get available prompts (not used in last session)
    List<int> availableIndices = [];
    for (int i = 0; i < _allPrompts.length; i++) {
      if (!lastUsedIndices.contains(i)) {
        availableIndices.add(i);
      }
    }
    
    // If we filtered too many, allow last used ones
    if (availableIndices.length < 2) {
      availableIndices = List.generate(_allPrompts.length, (i) => i);
    }
    
    // Randomly select 2 prompts
    availableIndices.shuffle(Random());
    final selectedIndices = availableIndices.take(2).toList();
    
    _selectedPrompts = selectedIndices.map((i) => _allPrompts[i]).toList();
    
    // Save for next time
    storage.setLastGroundingPrompts(selectedIndices);
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
                'Ground in the present',
                style: AppTypography.heading1,
              ),
              
              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's7_grounding'),

              const SizedBox(height: 24),
              
              // Grounding prompts
              // Grounding prompts
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Prompts
                      ..._selectedPrompts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final prompt = entry.value;
                        
                        return Column(
                          children: [
                            if (index > 0) const SizedBox(height: 32),
                            _buildPromptCard(prompt, index + 1),
                          ],
                        );
                      }).toList(),
                      
                      const SizedBox(height: 40),
                      
                      // Decorative element
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
                          'Take your time. Notice without judging.',
                          style: AppTypography.bodySmall.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Info tooltip
                      InfoTooltip(
                        text: 'Noticing the present pulls the brain out of worry loops.',
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bottom buttons
              Row(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard(String prompt, int number) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Number indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Prompt text
          Expanded(
            child: Text(
              prompt,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    // Mark grounding as completed
    context.read<SessionProvider>().markGroundingCompleted();
    
    // Navigate to Add-On Selector (S8)
    Navigator.of(context).pushNamed('/addon-selector');
  }
}
