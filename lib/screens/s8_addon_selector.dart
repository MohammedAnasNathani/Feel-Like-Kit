import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../services/smart_router_service.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
// Note: EliGuideBubble not used here per spec (Eli doesn't speak during complex choice)

/// S8: Optional Add-On Selector (Smart Routing)
/// 
/// Title: "One more thing might help"
/// 
/// Features:
/// - Dynamic options based on Mood/Intensity (via SmartRouterService)
/// - Exact 3 options + Skip
/// - Multi-path navigation
class AddonSelectorScreen extends StatefulWidget {
  const AddonSelectorScreen({super.key});

  @override
  State<AddonSelectorScreen> createState() => _AddonSelectorScreenState();
}

class _AddonSelectorScreenState extends State<AddonSelectorScreen> {
  String? _selectedAddon;
  late List<_AddonOption> _availableOptions;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  void _loadOptions() {
    // Define all possible add-on options
    // These maps match the IDs returned by SmartRouterService
    final allOptions = {
      'movement': _AddonOption(
        id: 'movement',
        title: 'Move your body',
        icon: Icons.directions_run,
        route: '/movement',
      ),
      'visualization': _AddonOption(
        id: 'visualization',
        title: 'Visualization',
        icon: Icons.spa,
        route: '/visualization',
      ),
      'thought_check': _AddonOption(
        id: 'thought_check',
        title: 'Check the thought',
        icon: Icons.psychology,
        route: '/thought-check',
      ),
      'journal': _AddonOption(
        id: 'journal',
        title: 'Journal',
        icon: Icons.edit_note,
        route: '/journal',
      ),
    };

    final session = context.read<SessionProvider>().currentSession;
    
    // Get smart recommendations based on current state
    if (session.feeling != null && session.intensity != null) {
      final recommendedTypes = SmartRouterService.getAddonOptions(
        session.feeling!, 
        session.intensity!
      );
      
      // Filter options
      _availableOptions = recommendedTypes
          .map((type) => allOptions[type])
          .whereType<_AddonOption>() // Filter out nulls if any type was invalid
          .toList();
    } else {
      // Fallback (shouldn't happen in flow)
      _availableOptions = [
        allOptions['visualization']!,
        allOptions['movement']!,
        allOptions['thought_check']!,
      ];
    }
    
    setState(() {});
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
                'One more thing might help',
                style: AppTypography.heading1,
              ),

              const SizedBox(height: 32),

              // Add-on options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ..._availableOptions.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChoiceCard(
                          text: option.title,
                          icon: option.icon,
                          isSelected: _selectedAddon == option.id,
                          onTap: () {
                            setState(() {
                              _selectedAddon = option.id;
                            });
                          },
                        ),
                      );
                    }), // Removed .toList() as map returns iterable which is fine for spread

                    const SizedBox(height: 24),

                    // Info tooltip
                    const InfoTooltip(
                      text: 'Different bodies need different inputs.',
                    ),
                  ],
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
                      onPressed: _selectedAddon != null ? _handleContinue : null,
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
    // Skip add-ons, go directly to Sustain Calm (S13)
    context.read<SessionProvider>().setAddonType(null);
    Navigator.of(context).pushNamed('/sustain-calm');
  }

  void _handleContinue() {
    if (_selectedAddon == null) return;

    final sessionProvider = context.read<SessionProvider>();
    sessionProvider.setAddonType(_selectedAddon);

    // Find the selected option and navigate to its route
    final selectedOption = _availableOptions.firstWhere(
      (option) => option.id == _selectedAddon,
    );

    Navigator.of(context).pushNamed(selectedOption.route);
  }
}

class _AddonOption {
  final String id;
  final String title;
  final IconData icon;
  final String route;

  _AddonOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
  });
}
