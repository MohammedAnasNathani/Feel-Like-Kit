import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S3: Safety Check Screen (Conditional)
/// 
/// Shown when: (Panic/Anxiety or Numb) AND High intensity
/// 
/// Prompt: "Are you safe right now?"
/// 
/// Features:
/// - 3 options: Yes / Not sure / No
/// - Inline crisis support block for "Not sure" or "No"
/// - Crisis buttons remain on screen after dialer
/// - All paths continue to Tool Selection (S4)
class SafetyCheckScreen extends StatefulWidget {
  const SafetyCheckScreen({super.key});

  @override
  State<SafetyCheckScreen> createState() => _SafetyCheckScreenState();
}

class _SafetyCheckScreenState extends State<SafetyCheckScreen> {
  String? _selectedOption; // 'yes', 'not_sure', 'no'
  bool _showCrisisSupport = false;

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
                'Are you safe right now?',
                style: AppTypography.heading1,
              ),
              
              const SizedBox(height: 16),

              // Eli Guide
              const EliGuideBubble(screenId: 's3_safety_check'),

              const SizedBox(height: 16),
              
              // Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ChoiceCard(
                        text: 'Yes',
                        isSelected: _selectedOption == 'yes',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'yes';
                            _showCrisisSupport = false;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      ChoiceCard(
                        text: 'Not sure',
                        isSelected: _selectedOption == 'not_sure',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'not_sure';
                            _showCrisisSupport = true;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      ChoiceCard(
                        text: 'No',
                        isSelected: _selectedOption == 'no',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'no';
                            _showCrisisSupport = true;
                          });
                        },
                      ),
                      
                      // Inline crisis support (shown for "Not sure" or "No")
                      if (_showCrisisSupport) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.crisisRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.crisisRed.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You\'re not alone. Support is available.',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Call 911
                              _buildCrisisButton(
                                icon: Icons.phone,
                                text: 'Call 911',
                                onTap: () => _callNumber('911'),
                              ),
                              const SizedBox(height: 12),
                              
                              // Call/text 988
                              _buildCrisisButton(
                                icon: Icons.support_agent,
                                text: 'Call or text 988',
                                onTap: () => _callNumber('988'),
                              ),
                              const SizedBox(height: 20),
                              
                              // Continue with tools option
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: _handleContinueWithTools,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textLight,
                                    side: BorderSide(
                                      color: AppColors.textLight.withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Continue with calming tools',
                                    style: AppTypography.buttonSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue button (shown when "Yes" selected or after crisis block shown)
              if (_selectedOption == 'yes' || _showCrisisSupport)
                PrimaryButton(
                  text: 'Continue',
                  onPressed: _handleContinue,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrisisButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.crisisRed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.textLight,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: AppTypography.buttonPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    // User returns to this screen after call
  }

  void _handleContinueWithTools() {
    _handleContinue();
  }

  void _handleContinue() {
    if (_selectedOption == null) return;
    
    // Save safety status
    context.read<SessionProvider>().setSafetyStatus(
      isSafe: _selectedOption == 'yes',
    );
    
    // Navigate to Tool Selection (S4)
    Navigator.of(context).pushNamed('/tool-selection');
  }
}
