import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../providers/session_provider.dart';
import '../widgets/eli_guide_bubble.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  // Rotating message pool per spec
  final List<String> _messagePool = [
    'You showed up. That matters.',
    'Small resets add up.',
    'This won\'t last forever.',
    'You handled something hard.',
    'Progress doesn\'t have to be loud.',
  ];

  late String _selectedMessage;

  @override
  void initState() {
    super.initState();
    // Randomly select a message
    _selectedMessage = _messagePool[DateTime.now().millisecond % _messagePool.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3933), // Dark brown bg
      body: SafeArea(
        child: Column(
          children: [
             const SizedBox(height: 60),

             // Green Checkmark Circle
             Container(
               width: 100,
               height: 100,
               decoration: const BoxDecoration(
                 color: AppColors.continueGreenEnd,
                 shape: BoxShape.circle,
               ),
               child: const Icon(
                 Icons.check,
                 color: Colors.white,
                 size: 60,
                 weight: 700, // Bold check
               ),
             ),

             const SizedBox(height: 32),

             // Title
             Text(
               'Session Complete',
               style: AppTypography.heading1.copyWith(
                 color: Colors.white,
                 fontSize: 32,
               ),
             ),
             
             const Spacer(),

             // Message Capsule - Now uses rotating message
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
               decoration: BoxDecoration(
                 color: Colors.white.withOpacity(0.1),
                 borderRadius: BorderRadius.circular(20),
                 border: Border.all(color: Colors.white.withOpacity(0.1)),
               ),
               child: Text(
                 _selectedMessage,
                 style: AppTypography.bodyLarge.copyWith(
                   color: Colors.white,
                   fontStyle: FontStyle.italic,
                   fontSize: 18,
                 ),
               ),
             ),
             
             const SizedBox(height: 24),

             // Eli Standing Image (Central focus - square with proper aspect ratio)
             Container(
               height: 200,
               width: 200,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 image: const DecorationImage(
                   image: AssetImage('assets/images/official_eli.jpg'),
                   fit: BoxFit.cover,
                   alignment: Alignment.topCenter, // Focus on character
                 ),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withOpacity(0.3),
                     blurRadius: 10,
                     offset: const Offset(0, 4),
                   ),
                 ],
               ),
             ),

             const Spacer(),

             // Done Button (Green)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24),
               child: _buildButton(
                 text: 'Done',
                 icon: Icons.home,
                 color: AppColors.primaryGreen,
                 onTap: () {
                   context.read<SessionProvider>().completeSession();
                   Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                 },
               ),
             ),
             
             const SizedBox(height: 16),
             
             // More Support Button (Outlined/Dark)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24),
               child: Container(
                 height: 56,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.3),
                   borderRadius: BorderRadius.circular(28),
                   border: Border.all(color: Colors.white.withOpacity(0.3)),
                 ),
                 child: Material(
                   color: Colors.transparent,
                   child: InkWell(
                     onTap: () => Navigator.of(context).pushNamed('/resources'),
                     borderRadius: BorderRadius.circular(28),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.help_outline, color: Colors.white.withOpacity(0.9)),
                         const SizedBox(width: 8),
                         Text(
                           'More support',
                           style: AppTypography.buttonSecondary.copyWith(
                             color: Colors.white.withOpacity(0.9),
                             fontSize: 16,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
             
             const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: AppTypography.buttonPrimary.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
