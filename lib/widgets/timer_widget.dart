import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Timer widget for breathing, tool use, and exercises
/// 
/// Features:
/// - Visual countdown (circular progress)
/// - Start/Pause functionality
/// - Auto-pause on navigation/app background
/// - Completion celebration with haptic
/// - Proper Resume state handling
class TimerWidget extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback? onComplete;
  final bool autoStart;

  const TimerWidget({
    super.key,
    required this.durationSeconds,
    this.onComplete,
    this.autoStart = false,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with WidgetsBindingObserver {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = widget.durationSeconds;
    if (widget.autoStart) {
      start();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause timer when app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_isRunning) {
        pause();
      }
    }
  }

  @override
  void deactivate() {
    // Pause timer when navigating away
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false; // Set directly, setState may not work here
    }
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    // Force rebuild when returning to show correct button state
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (_isRunning || _isCompleted) return;
    
    HapticFeedback.lightImpact();
    
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onComplete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    HapticFeedback.selectionClick();
    setState(() {
      _isRunning = false;
    });
  }

  void _onComplete() {
    _timer?.cancel();
    
    // Celebration haptic!
    HapticFeedback.heavyImpact();
    
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
    
    widget.onComplete?.call();
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.durationSeconds;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  double get _progress {
    return 1.0 - (_remainingSeconds / widget.durationSeconds);
  }

  String get _timeDisplay {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _buttonText {
    if (_isCompleted) return 'Done!';
    if (_isRunning) return 'Pause';
    if (_remainingSeconds < widget.durationSeconds) return 'Resume';
    return 'Start';
  }

  IconData get _buttonIcon {
    if (_isCompleted) return Icons.check;
    if (_isRunning) return Icons.pause;
    return Icons.play_arrow;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular progress indicator
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 8,
                backgroundColor: AppColors.surfaceWarm,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isCompleted ? AppColors.primaryGreen : AppColors.primaryGreen,
                ),
              ),
            ),
            // Time display or checkmark
            _isCompleted
                ? const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: AppColors.primaryGreen,
                  )
                : Text(
                    _timeDisplay,
                    style: AppTypography.timer,
                  ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Start/Pause/Done button
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isCompleted ? null : (_isRunning ? pause : start),
            icon: Icon(
              _buttonIcon,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              _buttonText,
              style: AppTypography.buttonSecondary.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCompleted 
                  ? AppColors.primaryGreen.withOpacity(0.7)
                  : (_isRunning ? AppColors.secondaryPurple : AppColors.primaryGreen),
              foregroundColor: AppColors.textLight,
              disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.5),
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              elevation: _isCompleted ? 0 : 2,
            ),
          ),
        ),
        
        // Completion celebration
        if (_isCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎉',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Great job!',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
