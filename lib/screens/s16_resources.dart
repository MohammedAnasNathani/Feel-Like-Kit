import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/primary_button.dart';

/// S16: Resources Screen
/// 
/// Title: "More support (if you want it)"
/// 
/// Features:
/// - Crisis buttons (911, 988)
/// - External links (Psychology Today, FindTreatment.gov, Open Path)
/// - Close button → Home
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          ),
        ),
        title: Text(
          'Resources',
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
              const SizedBox(height: 24),

              // Title
              Text(
                'More support (if you want it)',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 32),

              // Crisis Section
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
                      'Immediate Support',
                      style: AppTypography.heading3,
                    ),
                    const SizedBox(height: 16),
                    _buildCrisisButton(
                      context,
                      icon: Icons.phone,
                      title: 'Call 911',
                      subtitle: 'Emergency services',
                      onTap: () => _callNumber('911'),
                    ),
                    const SizedBox(height: 12),
                    _buildCrisisButton(
                      context,
                      icon: Icons.support_agent,
                      title: 'Call or text 988',
                      subtitle: 'Suicide & Crisis Lifeline',
                      onTap: () => _callNumber('988'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Professional Help Section
              Text(
                'Find Professional Help',
                style: AppTypography.heading3,
              ),

              const SizedBox(height: 16),

              _buildResourceLink(
                icon: Icons.psychology,
                title: 'Psychology Today',
                subtitle: 'Find a therapist near you',
                url: 'https://www.psychologytoday.com/us/therapists',
              ),

              const SizedBox(height: 12),

              _buildResourceLink(
                icon: Icons.local_hospital,
                title: 'FindTreatment.gov',
                subtitle: 'Mental health & substance use treatment',
                url: 'https://findtreatment.gov',
              ),

              const SizedBox(height: 12),

              _buildResourceLink(
                icon: Icons.favorite,
                title: 'Open Path Psychotherapy',
                subtitle: 'Affordable therapy (\$30-\$80/session)',
                url: 'https://openpathcollective.org',
              ),

              const SizedBox(height: 32),

              // About Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About This App',
                      style: AppTypography.heading3,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Feel Like 💩 Kit offers evidence-based self-calming and grounding tools. '
                      'It is not medical care, therapy, or emergency support.\n\n'
                      'This app is free, offline, and does not collect any data.',
                      style: AppTypography.bodyMedium.copyWith(height: 1.7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Close button
              PrimaryButton(
                text: 'Close',
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrisisButton(
    BuildContext context, {
    required IconData icon,
    required String title,
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
            color: AppColors.crisisRed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withOpacity(0.2),
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
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.phone,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceLink({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: AppColors.textMuted,
                size: 20,
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

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
