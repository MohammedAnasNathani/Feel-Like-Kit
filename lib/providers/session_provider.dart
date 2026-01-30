import 'package:flutter/material.dart';
import '../models/session_data.dart';
import '../models/feeling.dart';
import '../models/intensity.dart';
import '../services/storage_service.dart';

/// Session provider managing the Calm Mode state machine
class SessionProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  
  // Current session
  SessionData _currentSession = SessionData();
  SessionData get currentSession => _currentSession;

  // ============= SESSION MANAGEMENT =============

  /// Start a new session
  void startNewSession() {
    _currentSession = SessionData();
    notifyListeners();
  }

  /// Complete current session and save
  Future<void> completeSession() async {
    _currentSession = _currentSession.copyWith(
      endTime: DateTime.now(),
      completed: true,
    );
    await _storage.saveSession(_currentSession);
    
    // Update recent selections
    if (_currentSession.feeling != null) {
      await _storage.setRecentFeeling(_currentSession.feeling!.name);
    }
    if (_currentSession.intensity != null) {
      await _storage.setRecentIntensity(_currentSession.intensity!.name);
    }
    if (_currentSession.toolId != null) {
      await _storage.addTool(_currentSession.toolId!);
    }
    
    notifyListeners();
  }

  // ============= STATE UPDATES =============

  /// S1: Set feeling
  void setFeeling(Feeling feeling) {
    _currentSession = _currentSession.copyWith(feeling: feeling);
    notifyListeners();
  }

  /// S2: Set intensity
  void setIntensity(Intensity intensity) {
    _currentSession = _currentSession.copyWith(intensity: intensity);
    notifyListeners();
  }

  /// S3: Set safety status
  void setSafetyStatus({bool? isSafe}) {
    _currentSession = _currentSession.copyWith(isSafe: isSafe);
    notifyListeners();
  }

  /// S4: Set selected tool
  void setTool(String toolId) {
    _currentSession = _currentSession.copyWith(toolId: toolId);
    notifyListeners();
  }

  /// S6: Mark breathing as completed
  void markBreathingCompleted() {
    _currentSession = _currentSession.copyWith(breathingCompleted: true);
    notifyListeners();
  }

  /// S7: Mark grounding as completed
  void markGroundingCompleted() {
    _currentSession = _currentSession.copyWith(groundingCompleted: true);
    notifyListeners();
  }

  /// S8: Set optional add-on type
  void setAddonType(String? addonType) {
    _currentSession = _currentSession.copyWith(addonType: addonType);
    notifyListeners();
  }

  /// S9: Set movement type
  void setMovementType(String movementType) {
    _currentSession = _currentSession.copyWith(movementType: movementType);
    notifyListeners();
  }

  /// S11: Set thought category
  void setThoughtCategory(String thoughtCategory) {
    _currentSession = _currentSession.copyWith(thoughtCategory: thoughtCategory);
    notifyListeners();
  }

  /// S11b: Set challenge question
  void setChallengeQuestion(String question) {
    _currentSession = _currentSession.copyWith(challengeQuestion: question);
    notifyListeners();
  }

  /// S12: Set journal type and content
  void setJournal({String? journalType, String? content}) {
    _currentSession = _currentSession.copyWith(
      journalType: journalType,
      journalContent: content,
    );
    notifyListeners();
  }

  /// S13: Set sustain action
  void setSustainAction(String action) {
    _currentSession = _currentSession.copyWith(sustainAction: action);
    notifyListeners();
  }

  /// S14: Add saved item
  void addSavedItem(String item) {
    final updated = List<String>.from(_currentSession.savedItems)..add(item);
    _currentSession = _currentSession.copyWith(savedItems: updated);
    notifyListeners();
  }

  // ============= NAVIGATION HELPERS =============

  /// Check if safety check should be shown
  bool get shouldShowSafetyCheck {
    return _currentSession.needsSafetyCheck;
  }

  /// Get next route after intensity selection
  String getNextRouteAfterIntensity() {
    return shouldShowSafetyCheck ? '/safety-check' : '/tool-selection';
  }

  /// Get next route after optional add-on selector
  String getNextRouteAfterAddon(String? addonType) {
    if (addonType == null) return '/sustain-calm';
    
    switch (addonType) {
      case 'movement':
        return '/movement';
      case 'visualization':
        return '/visualization';
      case 'thought_check':
        return '/thought-check';
      case 'journal':
        return '/journal';
      default:
        return '/sustain-calm';
    }
  }

  /// Reset session (for testing or restart)
  void reset() {
    _currentSession = SessionData();
    notifyListeners();
  }
}
