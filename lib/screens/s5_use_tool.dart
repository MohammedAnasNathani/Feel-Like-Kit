import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/tool.dart';
import '../providers/session_provider.dart';
import '../widgets/eli_guide_bubble.dart';

class UseToolScreen extends StatefulWidget {
  const UseToolScreen({super.key});

  @override
  State<UseToolScreen> createState() => _UseToolScreenState();
}

class _UseToolScreenState extends State<UseToolScreen> with WidgetsBindingObserver {
  Timer? _timer;
  int _secondsRemaining = 45;
  int _totalSeconds = 45;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _showTooltip = false;
  bool _wasRunningBeforePause = false; // Track state before pause
  
  Tool? _tool;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen to app lifecycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTool();
    });
  }

  void _loadTool() {
    final session = context.read<SessionProvider>().currentSession;
    if (session.toolId == null) return;
    
    final tool = Tools.getById(session.toolId!);
    if (tool != null) {
      setState(() {
        _tool = tool;
        _totalSeconds = tool.durationSeconds;
        _secondsRemaining = tool.durationSeconds;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause timer when app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_isRunning) {
        _wasRunningBeforePause = true;
        _pauseTimer();
      }
    }
  }

  @override
  void deactivate() {
    // Pause timer when navigating away from this screen
    // Note: Don't use setState here as it doesn't work in deactivate
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false; // Set directly, not via setState
      _wasRunningBeforePause = true;
    }
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    // Force rebuild when returning to this screen
    // This ensures the button shows correct state (Resume instead of Pause)
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _isRunning = false;
      });
    } else {
      _isRunning = false;
    }
  }

  void _toggleTimer() {
    HapticFeedback.lightImpact();
    if (_isRunning) {
      _pauseTimer();
    } else {
      setState(() {
        _isRunning = true;
        _wasRunningBeforePause = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel();
          _onTimerComplete();
        }
      });
    }
  }

  void _onTimerComplete() {
    // Celebration feedback
    HapticFeedback.heavyImpact();
    
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tool == null) return const Scaffold(body: SizedBox.shrink());

    return Scaffold(
      backgroundColor: const Color(0xFF4A3933),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feel Like 💩 Kit',
          style: AppTypography.appTitle.copyWith(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Character Image
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/official_eli.jpg'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
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

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Let\'s reset your body',
                      style: AppTypography.heading2.copyWith(
                        color: Colors.white, 
                        fontSize: 24,
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Eli Guide
                    const EliGuideBubble(screenId: 's5_use_tool'),

                    const SizedBox(height: 16),

                    // Tool Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _tool!.displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instruction Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _tool!.instruction,
                            textAlign: TextAlign.center,
                            style: AppTypography.heading3.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nothing to figure out right now.',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Timer
                    GestureDetector(
                      onTap: _toggleTimer,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: 1.0 - (_secondsRemaining / _totalSeconds),
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withOpacity(0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                            ),
                          ),
                          Text(
                            '0:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: AppTypography.heading1.copyWith(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Start/Pause Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isCompleted ? null : _toggleTimer,
                        icon: Icon(
                          _isCompleted 
                              ? Icons.check 
                              : (_isRunning ? Icons.pause : Icons.play_arrow),
                          color: Colors.white,
                        ),
                        label: Text(
                          _isCompleted 
                              ? 'Done!' 
                              : (_isRunning ? 'Pause' : (_secondsRemaining < _totalSeconds ? 'Resume' : 'Start')),
                          style: AppTypography.buttonPrimary.copyWith(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCompleted 
                              ? AppColors.primaryGreen.withOpacity(0.7) 
                              : AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: _isCompleted ? 0 : 2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Completion celebration
                    if (_isCompleted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen.withOpacity(0.2),
                              AppColors.primaryGreen.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '🎉',
                              style: TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Great job!',
                              style: AppTypography.heading3.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You took time for yourself',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (!_isCompleted)
                      const SizedBox(height: 16),
                    
                    // Why this helps - EXPANDABLE
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _showTooltip = !_showTooltip;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showTooltip ? Icons.info : Icons.info_outline,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Why this helps',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            _showTooltip ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white.withOpacity(0.6),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    
                    // Expandable tooltip content
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _showTooltip
                          ? Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Text(
                                _tool?.whyItHelps ?? 'This technique helps you reset and refocus.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Fixed bottom buttons - ALWAYS VISIBLE
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3933),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleContinue,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.8),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    HapticFeedback.selectionClick();
    
    // Properly pause the timer before navigating
    _timer?.cancel();
    
    // Set _isRunning to false so button shows "Resume" when returning
    setState(() {
      _isRunning = false;
    });
    
    // Navigate and refresh UI when returning
    Navigator.of(context).pushNamed('/breathing').then((_) {
      // When user comes back via back button, force refresh
      if (mounted) {
        setState(() {});
      }
    });
  }
}
