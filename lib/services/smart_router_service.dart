import '../models/feeling.dart';
import '../models/intensity.dart';
import '../models/tool.dart';

/// Service that implements the Version 1.5 "Smart Logic"
/// Handles dynamic tool recommendations, add-on routing, and Eli's contextual messages.
class SmartRouterService {
  
  // ============= TOOL RECOMMENDATIONS (S4) =============
  
  /// Get recommended tool IDs based on feeling and intensity
  static List<String> getRecommendedToolIds(Feeling feeling, Intensity intensity) {
    switch (feeling) {
      case Feeling.panicAnxiety:
        return [
          'KIT_SOUR_CANDY',
          'SUB_COLD_WATER', 
          'NONE_LONG_EXHALE',
          'NONE_FEET_PRESS',
        ];
      case Feeling.overwhelmed:
        return [
          'KIT_FIDGET_HANDHELD',
          'SUB_NOTES_APP',
          'NONE_5_COLORS', 
          'NONE_COUNT_BACK',
        ];
      case Feeling.angry:
        return [
          'KIT_FIDGET_HANDHELD',
          'NONE_SQUEEZE_RELEASE',
          'NONE_FEET_PRESS',
          'SUB_HOODIE_BLANKET',
        ];
      case Feeling.sad:
        return [
          'KIT_FACEMASK', 
          'KIT_BRACELET_MESSAGE', 
          'SUB_WARM_DRINK',
          'KIT_MUSIC',
        ];
      case Feeling.numb:
        return [
          'KIT_SOUR_CANDY',
          'KIT_COOL_PACK', 
          'NONE_5_COLORS', 
          'SUB_KEYS_PEN',
        ];
      case Feeling.notSure:
        return [
          'KIT_GUM',
          'NONE_LONG_EXHALE',
          'NONE_5_COLORS',
          'KIT_MUSIC',
        ];
    }
  }

  // ============= ADD-ON ROUTING (S8) =============

  /// Get the 3 optional add-on types to show on S8
  /// Returns list of types: 'movement', 'visualization', 'thought_check', 'journal'
  static List<String> getAddonOptions(Feeling feeling, Intensity intensity) {
    switch (feeling) {
      case Feeling.panicAnxiety:
        return ['movement', 'visualization', 'thought_check'];
      
      case Feeling.overwhelmed:
        return ['visualization', 'thought_check', 'journal'];
      
      case Feeling.angry:
        // Doc says: Movement, Thought Check, Skip encouraged.
        // We will provide movement and thought_check. 
        // We'll fill the third slot with visualization as a backup or leave it to UI to handle just 2?
        // Let's provide 3 to keep UI consistent, but maybe 'visualization' as a soft option.
        return ['movement', 'thought_check', 'visualization']; 
        
      case Feeling.sad:
        return ['visualization', 'journal', 'thought_check'];
        
      case Feeling.numb:
        return ['movement', 'visualization', 'journal'];
        
      case Feeling.notSure:
        return ['visualization', 'movement', 'thought_check'];
    }
  }
  
  // ============= ELI CONTEXTUAL MESSAGES =============
  
  /// Get Eli's message for a specific screen context
  /// Get Eli's message for a specific screen context
  static String? getEliMessage({
    required String screenId, 
    Feeling? feeling, 
    Intensity? intensity,
  }) {
    // 1. Check for specific screen + feeling + intensity overrides
    // (None in MVP, but structure allows it)
    
    // 2. Check for specific screen + feeling
    if (_eliFeelingSpecific[screenId] != null && 
        _eliFeelingSpecific[screenId]!.containsKey(feeling)) {
      return _eliFeelingSpecific[screenId]![feeling];
    }
    
    // 3. Fallback to general screen default
    return _eliGeneralDefaults[screenId];
  }

  // --- ELI SCRIPT LIBRARY ---
  
  static final Map<String, String> _eliGeneralDefaults = {
    // ROLE 1: Orienting
    's1_feeling_checkin': "There’s no wrong answer here.",
    's2_intensity': "Just pick what feels closest.",
    's4_tool_selection': "We’ll go one step at a time.",
    
    // ROLE 2: Permission-Giver
    's3_safety_check': "Support is here if you need it.",
    
    // ROLE 3: Somatic Coach
    's5_use_tool': "You don't have to try hard.",
    's6_breathing': "Let your body settle.",
    's7_grounding': "Just notice where you are.",
    's9_movement': "Movement often helps here.",
    
    // ROLE 4: Cognitive Guardrail
    's11_thought_check': "We’re just checking, not arguing.",
    's11b_quick_challenge': "This is a pause, not a conclusion.",
    
    // ROLE 5: Closure
    's13_sustain_calm': "You showed up.",
    's14_reflect_prepare': "Slowing down matters.",
    's15_completion': "You can come back anytime.",
    
    // S8 - Only shown when user skips
    's8_addon_selector': "One thing at a time.",
  };
  
  static final Map<String, Map<Feeling, String>> _eliFeelingSpecific = {
    // S4 Tool Selection - Specific encouragement
    's4_tool_selection': {
      Feeling.panicAnxiety: "Let the body settle first.",
      Feeling.overwhelmed: "One thing at a time.",
      Feeling.angry: "No decisions right now.",
      Feeling.sad: "It’s okay to soften here.",
      Feeling.numb: "We’re just waking things up gently.",
      Feeling.notSure: "Any sensation counts.",
    },
    
    // S5 Use Tool - Specific coaching (overrides default)
    's5_use_tool': {
      Feeling.panicAnxiety: "This feeling can pass.",
      Feeling.angry: "Let the energy move.",
      Feeling.numb: "Just notice what happens.",
    },
    
    // S9 Movement - Specific guidance
    's9_movement': {
      Feeling.angry: "Strong movement is safe.",
      Feeling.numb: "Gentle movement wakes us up.",
    },
  };
}
