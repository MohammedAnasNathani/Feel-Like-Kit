import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../widgets/buttons/primary_button.dart';

/// S0: Disclaimer Gate Screen
/// 
/// Shown: If disclaimerAccepted != true
/// 
/// Features:
/// - Disclaimer text
/// - Crisis resource buttons (911, 988)
/// - Checkbox to accept
/// - Continue button (disabled until checkbox checked)
/// - Crisis resources modal
class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Before we begin',
                style: AppTypography.heading1,
              ),
              
              const SizedBox(height: 32),
              
              // Disclaimer text (exact copy from spec)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This app offers self-calming and grounding tools.\n\n'
                        'It is not medical care, therapy, or emergency support.\n\n'
                        'If you are in immediate danger or feel like you might hurt yourself or someone else, please get help right away.',
                        style: AppTypography.bodyLarge.copyWith(height: 1.7),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Crisis resource buttons
                      _buildCrisisButton(
                        icon: Icons.phone,
                        text: 'Call 911',
                        subtitle: 'Emergency services',
                        onTap: () => _callNumber('911'),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildCrisisButton(
                        icon: Icons.support_agent,
                        text: 'Call or text 988',
                        subtitle: 'Suicide & Crisis Lifeline',
                        onTap: () => _callNumber('988'),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Checkbox
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isAccepted = !_isAccepted;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _isAccepted,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAccepted = value ?? false;
                                    });
                                  },
                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.primaryGreen;
                                    }
                                    return Colors.transparent;
                                  }),
                                  checkColor: AppColors.textLight,
                                  side: BorderSide(
                                    color: _isAccepted 
                                        ? AppColors.primaryGreen 
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'I understand and want to continue',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bottom buttons
              Column(
                children: [
                  PrimaryButton(
                    text: 'Continue',
                    onPressed: _isAccepted ? _handleContinue : null,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  TextButton(
                    onPressed: _showCrisisResources,
                    child: Text(
                      'Crisis resources',
                      style: AppTypography.buttonSecondary.copyWith(
                        color: AppColors.textMuted,
                      ),
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

  Widget _buildCrisisButton({
    required IconData icon,
    required String text,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.crisisRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.crisisRed.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.crisisRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.textLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textMuted,
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
  }

  void _showCrisisResources() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crisis Resources',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: 20),
            _buildCrisisButton(
              icon: Icons.phone,
              text: 'Call 911',
              subtitle: 'Emergency services',
              onTap: () => _callNumber('911'),
            ),
            const SizedBox(height: 12),
            _buildCrisisButton(
              icon: Icons.support_agent,
              text: 'Call or text 988',
              subtitle: 'Suicide & Crisis Lifeline',
              onTap: () => _callNumber('988'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: AppTypography.buttonSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (!_isAccepted) return;
    
    // Save disclaimer acceptance
    final storage = StorageService();
    await storage.setDisclaimerAccepted(true);
    
    // Navigate to home/feeling check-in
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
