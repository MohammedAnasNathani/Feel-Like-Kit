import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/session_data.dart';

/// Local storage service using SharedPreferences
/// Handles all offline data persistence per spec
class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // ============= STORAGE KEYS =============
  
  static const String _keyDisclaimerAccepted = 'disclaimerAccepted';
  static const String _keyLastSessionTimestamp = 'lastSessionTimestamp';
  static const String _keyRecentFeeling = 'recentFeeling';
  static const String _keyRecentIntensity = 'recentIntensity';
  static const String _keyToolHistory = 'toolHistory';
  static const String _keyEffectivenessHistory = 'effectivenessHistory';
  static const String _keySavedWhatHelped = 'savedWhatHelped';
  static const String _keySavedKitItems = 'savedKitItems';
  static const String _keyUserNotes = 'userNotes';
  static const String _keySessionHistory = 'sessionHistory';
  static const String _keyLastGroundingPrompts = 'lastGroundingPrompts';

  // ============= INITIALIZATION =============

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ============= DISCLAIMER =============

  /// Check if user has accepted disclaimer
  bool get disclaimerAccepted {
    return prefs.getBool(_keyDisclaimerAccepted) ?? false;
  }

  /// Set disclaimer accepted
  Future<void> setDisclaimerAccepted(bool value) async {
    await prefs.setBool(_keyDisclaimerAccepted, value);
  }

  // ============= SESSION TRACKING =============

  /// Get last session timestamp
  DateTime? get lastSessionTimestamp {
    final timestamp = prefs.getString(_keyLastSessionTimestamp);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  /// Update last session timestamp
  Future<void> updateLastSessionTimestamp() async {
    await prefs.setString(
      _keyLastSessionTimestamp,
      DateTime.now().toIso8601String(),
    );
  }

  // ============= RECENT SELECTIONS =============

  /// Get recent feeling
  String? get recentFeeling {
    return prefs.getString(_keyRecentFeeling);
  }

  /// Set recent feeling
  Future<void> setRecentFeeling(String feeling) async {
    await prefs.setString(_keyRecentFeeling, feeling);
  }

  /// Get recent intensity
  String? get recentIntensity {
    return prefs.getString(_keyRecentIntensity);
  }

  /// Set recent intensity
  Future<void> setRecentIntensity(String intensity) async {
    await prefs.setString(_keyRecentIntensity, intensity);
  }

  // ============= TOOL HISTORY (Last 10) =============

  /// Get tool history
  List<String> get toolHistory {
    return prefs.getStringList(_keyToolHistory) ?? [];
  }

  /// Add tool to history (max 10)
  Future<void> addTool(String toolId) async {
    final history = toolHistory;
    history.insert(0, toolId);
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    await prefs.setStringList(_keyToolHistory, history);
  }

  // ============= EFFECTIVENESS TRACKING =============

  /// Get effectiveness ratings history
  List<int> get effectivenessHistory {
    final stringList = prefs.getStringList(_keyEffectivenessHistory) ?? [];
    return stringList.map((e) => int.parse(e)).toList();
  }

  /// Add effectiveness rating (1-5 scale)
  Future<void> addEffectivenessRating(int rating) async {
    final history = effectivenessHistory;
    history.insert(0, rating);
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    await prefs.setStringList(
      _keyEffectivenessHistory,
      history.map((e) => e.toString()).toList(),
    );
  }

  // ============= SAVED ITEMS =============

  /// Get saved "what helped" tool IDs
  List<String> get savedWhatHelped {
    return prefs.getStringList(_keySavedWhatHelped) ?? [];
  }

  /// Add to "what helped"
  Future<void> addToWhatHelped(String toolId) async {
    final saved = savedWhatHelped;
    if (!saved.contains(toolId)) {
      saved.add(toolId);
      await prefs.setStringList(_keySavedWhatHelped, saved);
    }
  }

  /// Remove from "what helped"
  Future<void> removeFromWhatHelped(String toolId) async {
    final saved = savedWhatHelped;
    saved.remove(toolId);
    await prefs.setStringList(_keySavedWhatHelped, saved);
  }

  /// Get saved kit items
  List<String> get savedKitItems {
    return prefs.getStringList(_keySavedKitItems) ?? [];
  }

  /// Add to kit list
  Future<void> addToKitList(String itemId) async {
    final saved = savedKitItems;
    if (!saved.contains(itemId)) {
      saved.add(itemId);
      await prefs.setStringList(_keySavedKitItems, saved);
    }
  }

  // ============= USER NOTES (Last 10) =============

  /// Get user notes
  List<Map<String, dynamic>> get userNotes {
    final jsonList = prefs.getStringList(_keyUserNotes) ?? [];
    return jsonList.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  /// Add user note
  Future<void> addNote({
    required String type,
    required String content,
  }) async {
    final notes = userNotes;
    notes.insert(0, {
      'type': type,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
    if (notes.length > 10) {
      notes.removeRange(10, notes.length);
    }
    await prefs.setStringList(
      _keyUserNotes,
      notes.map((note) => jsonEncode(note)).toList(),
    );
  }

  // ============= SESSION HISTORY (Last 10) =============

  /// Get session history
  List<SessionData> get sessionHistory {
    final jsonList = prefs.getStringList(_keySessionHistory) ?? [];
    return jsonList
        .map((json) => SessionData.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Save session to history
  Future<void> saveSession(SessionData session) async {
    final history = sessionHistory;
    history.insert(0, session);
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    await prefs.setStringList(
      _keySessionHistory,
      history.map((s) => jsonEncode(s.toJson())).toList(),
    );
    await updateLastSessionTimestamp();
  }

  // ============= ROTATION TRACKING =============

  /// Get last used grounding prompts (for rotation)
  List<int> get lastGroundingPrompts {
    final stringList = prefs.getStringList(_keyLastGroundingPrompts) ?? [];
    return stringList.map((e) => int.parse(e)).toList();
  }

  /// Set last used grounding prompts
  Future<void> setLastGroundingPrompts(List<int> indices) async {
    await prefs.setStringList(
      _keyLastGroundingPrompts,
      indices.map((e) => e.toString()).toList(),
    );
  }

  // ============= CLEAR DATA =============

  /// Clear all data (for testing or user request)
  Future<void> clearAll() async {
    await prefs.clear();
  }

  /// Clear only session data (keep preferences)
  Future<void> clearSessions() async {
    await prefs.remove(_keySessionHistory);
    await prefs.remove(_keyToolHistory);
    await prefs.remove(_keyEffectivenessHistory);
    await prefs.remove(_keyUserNotes);
  }
}
