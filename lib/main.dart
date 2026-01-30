import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'providers/session_provider.dart';
import 'screens/s0_disclaimer.dart';
import 'screens/s1_feeling_checkin.dart';
import 'screens/s2_intensity.dart';
import 'screens/s3_safety_check.dart';
import 'screens/s4_tool_selection.dart';
import 'screens/s5_use_tool.dart';
import 'screens/s6_breathing.dart';
import 'screens/s7_grounding.dart';
import 'screens/s8_addon_selector.dart';
import 'screens/s9_movement.dart';
import 'screens/s10_visualization.dart';
import 'screens/s11_thought_check.dart';
import 'screens/s11b_quick_challenge.dart';
import 'screens/s12_journal.dart';
import 'screens/s13_sustain_calm.dart';
import 'screens/s14_reflect_prepare.dart';
import 'screens/s15_completion.dart';
import 'screens/s16_resources.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF4A3933),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Lock orientation to portrait (better for calm mode experience)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const FeelLikeKitApp());
}

class FeelLikeKitApp extends StatelessWidget {
  const FeelLikeKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Session state management
        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Feel Like 💩 Kit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        
        // Initial route based on disclaimer acceptance
        home: const AppStartScreen(),
        
        // Named routes for navigation
        routes: {
          '/disclaimer': (context) => const DisclaimerScreen(),
          '/home': (context) => const FeelingCheckInScreen(),
          '/intensity': (context) => const IntensityScreen(),
          '/safety-check': (context) => const SafetyCheckScreen(),
          '/tool-selection': (context) => const ToolSelectionScreen(),
          '/use-tool': (context) => const UseToolScreen(),
          '/breathing': (context) => const BreathingScreen(),
          '/grounding': (context) => const GroundingScreen(),
          '/addon-selector': (context) => const AddonSelectorScreen(),
          '/movement': (context) => const MovementScreen(),
          '/visualization': (context) => const VisualizationScreen(),
          '/thought-check': (context) => const ThoughtCheckScreen(),
          '/quick-challenge': (context) => const QuickChallengeScreen(),
          '/journal': (context) => const JournalScreen(),
          '/sustain-calm': (context) => const SustainCalmScreen(),
          '/reflect-prepare': (context) => const ReflectPrepareScreen(),
          '/completion': (context) => const CompletionScreen(),
          '/resources': (context) => const ResourcesScreen(),
        },
      ),
    );
  }
}

/// App start screen - checks disclaimer and routes appropriately
class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    
    // Check if disclaimer was accepted
    return FutureBuilder<bool>(
      future: Future.value(storage.disclaimerAccepted),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading screen
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Route to disclaimer or home
        final disclaimerAccepted = snapshot.data ?? false;
        
        // Navigate after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (disclaimerAccepted) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            Navigator.of(context).pushReplacementNamed('/disclaimer');
          }
        });
        
        // Show blank screen while navigating
        return const Scaffold(
          body: SizedBox.shrink(),
        );
      },
    );
  }
}
