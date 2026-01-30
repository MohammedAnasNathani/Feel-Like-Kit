import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/tool.dart';
import '../providers/session_provider.dart';
import '../services/smart_router_service.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/eli_guide_bubble.dart';

/// S4: Tool Selection Screen (Smart Logic Activated)
/// 
/// Title: "Let's help your body first"
/// Subtext: "Grab one thing if you can"
/// 
/// Features:
/// - Smart Recommendations (Top 3-4 based on mood)
/// - 3 standard sections: My Kit / Nearby / No Items
/// - Eli Guide Bubble context
/// - Single selection
class ToolSelectionScreen extends StatefulWidget {
  const ToolSelectionScreen({super.key});

  @override
  State<ToolSelectionScreen> createState() => _ToolSelectionScreenState();
}

class _ToolSelectionScreenState extends State<ToolSelectionScreen> {
  Tool? _selectedTool;
  List<Tool> _recommendedTools = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    // We need to defer this slightly to safely access context/provider or just do it in build?
    // Doing it here is fine if we use read, but we need session data.
    // Better to do in didChangeDependencies or build, but let's try post frame to be safe or just computed in build.
    // For simplicity/performance, let's compute in build is fine, list is small.
  }

  @override
  Widget build(BuildContext context) {
    // Compute recommendations on fly
    final session = context.watch<SessionProvider>().currentSession;
    if (session.feeling != null && session.intensity != null) {
      final recommendedIds = SmartRouterService.getRecommendedToolIds(
        session.feeling!, 
        session.intensity!
      );
      _recommendedTools = Tools.allTools
          .where((t) => recommendedIds.contains(t.id))
          .toList();
    }

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
        child: Column(
          children: [
            // Header section (scrollable with content)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    Text(
                      'Let\'s help your body first',
                      style: AppTypography.heading1.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Grab one thing if you can',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Eli Guide Bubble
                    const EliGuideBubble(screenId: 's4_tool_selection'),

                    // Recommended Section
                    if (_recommendedTools.isNotEmpty) ...[
                      _buildSection(
                        title: 'Recommended for You',
                        icon: Icons.star,
                        tools: _recommendedTools,
                        sectionColor: AppColors.primaryGreen.withOpacity(0.15),
                        isRecommended: true,
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      const SizedBox(height: 24),
                    ],
                    
                    // Section A: My Kit
                    _buildSection(
                      title: 'My Kit',
                      icon: Icons.backpack_outlined,
                      tools: Tools.kitTools,
                      sectionColor: AppColors.primaryGreen.withOpacity(0.05),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Section B: Nearby (No Kit)
                    _buildSection(
                      title: 'Nearby (No Kit)',
                      icon: Icons.search,
                      tools: Tools.nearbyTools,
                      sectionColor: AppColors.secondaryPurple.withOpacity(0.05),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Section C: No Items
                    _buildSection(
                      title: 'No Items',
                      icon: Icons.self_improvement,
                      tools: Tools.noItemTools,
                      sectionColor: AppColors.infoBlue.withOpacity(0.05),
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ),
              ),
            ),
            
            // Bottom buttons (fixed)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selection indicator
                    if (_selectedTool != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Selected: ${_selectedTool!.displayName}',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedTool = null;
                                });
                              },
                              child: Text(
                                'Change',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'Skip',
                            onPressed: () {
                              // Can skip tool selection and use breathing/grounding only
                              Navigator.of(context).pushNamed('/breathing');
                            },
                            icon: Icons.skip_next,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            text: 'Start',
                            onPressed: _selectedTool != null ? _handleStart : null,
                            icon: Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Tool> tools,
    required Color sectionColor,
    bool isRecommended = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: sectionColor,
            borderRadius: BorderRadius.circular(8),
            border: isRecommended ? Border.all(color: AppColors.primaryGreen.withOpacity(0.3)) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isRecommended ? AppColors.primaryGreen : AppColors.textLight,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.heading3.copyWith(
                  fontSize: 16,
                  color: isRecommended ? AppColors.primaryGreen : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tools in this section
        ...tools.map((tool) {
          final isSelected = _selectedTool?.id == tool.id;
          
          // Determine subtitle based on category if recommended
          String? subtitle;
          if (isRecommended) {
            switch (tool.category) {
              case ToolCategory.kit:
                subtitle = "In your Kit";
                break;
              case ToolCategory.nearby:
                subtitle = "Nearby item";
                break;
              case ToolCategory.noItems:
                subtitle = "No items needed";
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ChoiceCard(
              text: tool.displayName,
              subtitle: subtitle,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedTool = tool;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  void _handleStart() {
    if (_selectedTool == null) return;
    
    // Save selected tool to session
    context.read<SessionProvider>().setTool(_selectedTool!.id);
    
    // Navigate to Use Tool screen (S5)
    Navigator.of(context).pushNamed('/use-tool');
  }
}
