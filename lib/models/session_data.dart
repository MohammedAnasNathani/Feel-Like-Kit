import 'feeling.dart';
import 'intensity.dart';

/// Session data model that tracks a complete Calm Mode session
/// Matches the state machine flow from S0-S16
class SessionData {
  // ============= CORE STATE =============
  
  /// S1: Selected feeling
  Feeling? feeling;
  
  /// S2: Selected intensity
  Intensity? intensity;
  
  /// S3: Safety check response (conditional)
  bool? isSafe;
  
  /// S4: Selected tool ID
  String? toolId;
  
  /// S6: Breathing completed
  bool breathingCompleted;
  
  /// S7: Grounding completed
  bool groundingCompleted;
  
  /// S8: Optional add-on type selected
  String? addonType; // 'movement', 'visualization', 'thought_check', 'journal'
  
  /// S9: Movement type if selected
  String? movementType; // 'gentle', 'fast'
  
  /// S11: Thought category if selected
  String? thoughtCategory;
  
  /// S11b: Challenge question selected
  String? challengeQuestion;
  
  /// S12: Journal type if selected
  String? journalType;
  
  /// S12: Journal content if user wrote something
  String? journalContent;
  
  /// S13: Sustain calm action selected
  String? sustainAction;
  
  /// S14: What user chose to remember
  List<String> savedItems;

  // ============= METADATA =============
  
  /// Session start time
  DateTime startTime;
  
  /// Session end time
  DateTime? endTime;
  
  /// Whether session was completed or abandoned
  bool completed;

  SessionData({
    this.feeling,
    this.intensity,
    this.isSafe,
    this.toolId,
    this.breathingCompleted = false,
    this.groundingCompleted = false,
    this.addonType,
    this.movementType,
    this.thoughtCategory,
    this.challengeQuestion,
    this.journalType,
    this.journalContent,
    this.sustainAction,
    List<String>? savedItems,
    DateTime? startTime,
    this.endTime,
    this.completed = false,
  })  : savedItems = savedItems ?? [],
        startTime = startTime ?? DateTime.now();

  // ============= SESSION ROUTING LOGIC =============

  /// Check if we need to show safety check screen (S3)
  /// Per spec: Show if (Panic/Anxiety or Numb) AND High intensity
  bool get needsSafetyCheck {
    if (feeling == null || intensity == null) return false;
    return feeling!.triggersSafetyCheck && intensity!.isHigh;
  }

  /// Get the appropriate path after intensity selection (S2)
  String get nextAfterIntensity {
    return needsSafetyCheck ? '/safety-check' : '/tool-selection';
  }

  // ============= JSON SERIALIZATION =============

  Map<String, dynamic> toJson() {
    return {
      'feeling': feeling?.name,
      'intensity': intensity?.name,
      'isSafe': isSafe,
      'toolId': toolId,
      'breathingCompleted': breathingCompleted,
      'groundingCompleted': groundingCompleted,
      'addonType': addonType,
      'movementType': movementType,
      'thoughtCategory': thoughtCategory,
      'challengeQuestion': challengeQuestion,
      'journalType': journalType,
      'journalContent': journalContent,
      'sustainAction': sustainAction,
      'savedItems': savedItems,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'completed': completed,
    };
  }

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      feeling: json['feeling'] != null 
        ? Feeling.values.byName(json['feeling']) 
        : null,
      intensity: json['intensity'] != null 
        ? Intensity.values.byName(json['intensity']) 
        : null,
      isSafe: json['isSafe'],
      toolId: json['toolId'],
      breathingCompleted: json['breathingCompleted'] ?? false,
      groundingCompleted: json['groundingCompleted'] ?? false,
      addonType: json['addonType'],
      movementType: json['movementType'],
      thoughtCategory: json['thoughtCategory'],
      challengeQuestion: json['challengeQuestion'],
      journalType: json['journalType'],
      journalContent: json['journalContent'],
      sustainAction: json['sustainAction'],
      savedItems: List<String>.from(json['savedItems'] ?? []),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      completed: json['completed'] ?? false,
    );
  }

  // ============= HELPER METHODS =============

  /// Create a copy with updated fields
  SessionData copyWith({
    Feeling? feeling,
    Intensity? intensity,
    bool? isSafe,
    String? toolId,
    bool? breathingCompleted,
    bool? groundingCompleted,
    String? addonType,
    String? movementType,
    String? thoughtCategory,
    String? challengeQuestion,
    String? journalType,
    String? journalContent,
    String? sustainAction,
    List<String>? savedItems,
    DateTime? startTime,
    DateTime? endTime,
    bool? completed,
  }) {
    return SessionData(
      feeling: feeling ?? this.feeling,
      intensity: intensity ?? this.intensity,
      isSafe: isSafe ?? this.isSafe,
      toolId: toolId ?? this.toolId,
      breathingCompleted: breathingCompleted ?? this.breathingCompleted,
      groundingCompleted: groundingCompleted ?? this.groundingCompleted,
      addonType: addonType ?? this.addonType,
      movementType: movementType ?? this.movementType,
      thoughtCategory: thoughtCategory ?? this.thoughtCategory,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      journalType: journalType ?? this.journalType,
      journalContent: journalContent ?? this.journalContent,
      sustainAction: sustainAction ?? this.sustainAction,
      savedItems: savedItems ?? this.savedItems,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completed: completed ?? this.completed,
    );
  }

  /// Get session duration
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  /// Get readable summary
  String get summary {
    final parts = <String>[];
    if (feeling != null) parts.add(feeling!.displayName);
    if (intensity != null) parts.add(intensity!.displayName);
    if (toolId != null) parts.add(toolId!);
    if (addonType != null) parts.add(addonType!);
    return parts.isEmpty ? 'Session' : parts.join(' → ');
  }
}
