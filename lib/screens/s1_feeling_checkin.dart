import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../models/feeling.dart';
import '../providers/session_provider.dart';
import '../widgets/buttons/emotion_button.dart';

class FeelingCheckInScreen extends StatefulWidget {
  const FeelingCheckInScreen({super.key});

  @override
  State<FeelingCheckInScreen> createState() => _FeelingCheckInScreenState();
}

class _FeelingCheckInScreenState extends State<FeelingCheckInScreen> {
  Feeling? _selectedFeeling;

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: AppTheme.theme.appBarTheme.systemOverlayStyle,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image - properly aligned to show Eli
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg_latest.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter, // Keep Eli visible at bottom
            ),
          ),

          // 2. Main Content Column
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                
                // Header
                Text(
                  'Feel Like 💩 Kit',
                  style: AppTypography.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'How are you feeling?',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Emotion Grid (6 buttons) - Non-scrollable
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    shrinkWrap: true, // Takes only needed space
                    physics: const NeverScrollableScrollPhysics(), // No internal scrolling
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.4, // Adjusted for button height
                    children: Feeling.values.map((feeling) {
                      return EmotionButton(
                        feeling: feeling,
                        isSelected: _selectedFeeling == feeling,
                        onTap: () {
                          setState(() {
                            _selectedFeeling = feeling;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                
                // Spacer to push content down
                const Spacer(flex: 1), 
                const SizedBox(height: 20), // Restored per user request 

                // Message Text - Moved UP to align with beard
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Take a moment.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w500, // Medium weight for exact replica
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.6),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We\'ll figure this out.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 19,
                            fontWeight: FontWeight.w500, // Medium weight for exact replica
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.6),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(flex: 6), // Maximize space to push buttons to extreme bottom

                // Bottom Action Area
                SizedBox(
                  height: 150, // Increased to prevent overflow
                  child: Stack(
                    children: [
                      // Gradient & Buttons
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16), // minimal bottom padding
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Action Buttons
                              Row(
                                children: [
                                  // Help Options
                                  Expanded(
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9A69F),
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _showCrisisResources(),
                                          borderRadius: BorderRadius.circular(28),
                                          child: Center(
                                            child: Text(
                                              'Help Options',
                                              style: AppTypography.bodyLarge.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Continue
                                  Expanded(
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFF66BB6A),
                                            Color(0xFF43A047),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _selectedFeeling != null ? _handleContinue : null,
                                          borderRadius: BorderRadius.circular(28),
                                          child: Center(
                                            child: Text(
                                              'Continue',
                                              style: AppTypography.bodyLarge.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Footer Links
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: _showCrisisResources,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Crisis Resources',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/resources');
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'About',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCrisisResources() {
    Navigator.of(context).pushNamed('/resources');
  }

  void _handleContinue() {
    if (_selectedFeeling == null) return;
    context.read<SessionProvider>().setFeeling(_selectedFeeling!);
    Navigator.of(context).pushNamed('/intensity');
  }
}
