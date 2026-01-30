import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/smart_router_service.dart';
import '../providers/session_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A widget that displays "Eli" contextual guidance messages.
/// Automatically queries SmartRouterService based on screenId and session context.
class EliGuideBubble extends StatelessWidget {
  final String screenId;

  const EliGuideBubble({
    super.key,
    required this.screenId,
  });

  @override
  Widget build(BuildContext context) {
    const eliImage = AssetImage('assets/images/eli_circle_face.jpg');

    return Consumer<SessionProvider>(
      builder: (context, session, _) {
        final sessionData = session.currentSession;
        
        final message = SmartRouterService.getEliMessage(
          screenId: screenId,
          feeling: sessionData.feeling, 
          intensity: sessionData.intensity,
        );

        if (message == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // Very subtle background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eli Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: eliImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter, // Ensure face is visible
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Message
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2), // Align with eye-line of avatar
                  child: Text(
                    message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textLight.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


