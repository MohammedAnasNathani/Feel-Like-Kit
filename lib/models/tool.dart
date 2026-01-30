/// Tool categories for organization
enum ToolCategory {
  kit,
  nearby,
  noItems;
}

/// Tool data model
class Tool {
  final String id;
  final String displayName;
  final String instruction;
  final ToolCategory category;
  final int durationSeconds;
  final String whyItHelps;

  const Tool({
    required this.id,
    required this.displayName,
    required this.instruction,
    required this.category,
    this.durationSeconds = 45,
    this.whyItHelps = 'Strong sensations send safety signals to your nervous system.',
  });
}

/// All available tools (per spec: 22 total)
class Tools {
  Tools._();

  // ============= KIT TOOLS (10) =============
  
  static const Tool sourCandy = Tool(
    id: 'KIT_SOUR_CANDY',
    displayName: 'Sour candy',
    instruction: 'Hold it on your tongue. Notice the taste.',
    category: ToolCategory.kit,
  );

  static const Tool gum = Tool(
    id: 'KIT_GUM',
    displayName: 'Gum',
    instruction: 'Chew slowly. Let your jaw move.',
    category: ToolCategory.kit,
  );

  static const Tool coolPack = Tool(
    id: 'KIT_COOL_PACK',
    displayName: 'Self-cooling ice pack',
    instruction: 'Place it on your neck or face.',
    category: ToolCategory.kit,
  );

  static const Tool fidgetHandheld = Tool(
    id: 'KIT_FIDGET_HANDHELD',
    displayName: 'Fidget (handheld)',
    instruction: 'Squeeze or twist at your own pace.',
    category: ToolCategory.kit,
  );

  static const Tool fidgetRing = Tool(
    id: 'KIT_FIDGET_RING',
    displayName: 'Fidget ring',
    instruction: 'Spin or move it gently. Keep using it.',
    category: ToolCategory.kit,
  );

  static const Tool earplugs = Tool(
    id: 'KIT_EARPLUGS',
    displayName: 'Earplugs',
    instruction: 'Put them in. Let things quiet down.',
    category: ToolCategory.kit,
  );

  static const Tool faceMask = Tool(
    id: 'KIT_FACEMASK',
    displayName: 'Face mask',
    instruction: 'Cover your eyes. Turn inward.',
    category: ToolCategory.kit,
  );

  static const Tool braceletMessage = Tool(
    id: 'KIT_BRACELET_MESSAGE',
    displayName: 'Bracelet (message reminder)',
    instruction: 'Touch it. Read the message once.',
    category: ToolCategory.kit,
  );

  static const Tool journal = Tool(
    id: 'KIT_JOURNAL',
    displayName: 'Journal',
    instruction: 'Write anything that comes out.',
    category: ToolCategory.kit,
    durationSeconds: 60,
  );

  static const Tool music = Tool(
    id: 'KIT_MUSIC',
    displayName: 'Music playlist',
    instruction: 'Let the sound carry you.',
    category: ToolCategory.kit,
    durationSeconds: 60,
  );

  // ============= NEARBY SUBSTITUTES (6) =============

  static const Tool coldWater = Tool(
    id: 'SUB_COLD_WATER',
    displayName: 'Cold water on face/wrists',
    instruction: 'Hold something cold. Notice the temperature.',
    category: ToolCategory.nearby,
  );

  static const Tool mintLemon = Tool(
    id: 'SUB_MINT_LEMON',
    displayName: 'Mint/lemon/strong taste',
    instruction: 'Notice the taste. Let it anchor you.',
    category: ToolCategory.nearby,
  );

  static const Tool keysPen = Tool(
    id: 'SUB_KEYS_PEN',
    displayName: 'Keys/pen/textured object',
    instruction: 'Hold it. Press it gently. Feel the edges.',
    category: ToolCategory.nearby,
  );

  static const Tool hoodeBlanket = Tool(
    id: 'SUB_HOODIE_BLANKET',
    displayName: 'Hoodie/blanket',
    instruction: 'Wrap up. Let the pressure steady you.',
    category: ToolCategory.nearby,
  );

  static const Tool warmDrink = Tool(
    id: 'SUB_WARM_DRINK',
    displayName: 'Warm drink',
    instruction: 'Hold warmth in your hands. Sip slowly.',
    category: ToolCategory.nearby,
  );

  static const Tool notesApp = Tool(
    id: 'SUB_NOTES_APP',
    displayName: 'Notes app',
    instruction: 'Write one line. Just one.',
    category: ToolCategory.nearby,
    durationSeconds: 30,
  );

  static const Tool freshAir = Tool(
    id: 'SUB_FRESH_AIR',
    displayName: 'Step outside / fresh air',
    instruction: 'If you can, take one breath of fresh air.',
    category: ToolCategory.nearby,
    durationSeconds: 30,
  );

  // ============= NO ITEMS NEEDED (6) =============

  static const Tool longExhale = Tool(
    id: 'NONE_LONG_EXHALE',
    displayName: 'Long exhale',
    instruction: 'Breathe out slowly. Longer than you breathe in.',
    category: ToolCategory.noItems,
  );

  static const Tool squeezeRelease = Tool(
    id: 'NONE_SQUEEZE_RELEASE',
    displayName: 'Squeeze & release hands',
    instruction: 'Squeeze your hands. Release. Repeat.',
    category: ToolCategory.noItems,
  );

  static const Tool feetPress = Tool(
    id: 'NONE_FEET_PRESS',
    displayName: 'Press feet into floor',
    instruction: 'Press your feet into the floor. Hold. Release.',
    category: ToolCategory.noItems,
  );

  static const Tool fiveColors = Tool(
    id: 'NONE_5_COLORS',
    displayName: 'Name 5 colors',
    instruction: 'Name five colors you can see.',
    category: ToolCategory.noItems,
    durationSeconds: 30,
  );

  static const Tool countBack = Tool(
    id: 'NONE_COUNT_BACK',
    displayName: 'Count backward',
    instruction: 'Count backward by 3s.',
    category: ToolCategory.noItems,
    durationSeconds: 30,
  );

  // ============= TOOL LISTS =============

  static const List<Tool> kitTools = [
    sourCandy,
    gum,
    coolPack,
    fidgetHandheld,
    fidgetRing,
    earplugs,
    faceMask,
    braceletMessage,
    journal,
    music,
  ];

  static const List<Tool> nearbyTools = [
    coldWater,
    mintLemon,
    keysPen,
    hoodeBlanket,
    warmDrink,
    notesApp,
    freshAir,
  ];

  static const List<Tool> noItemTools = [
    longExhale,
    squeezeRelease,
    feetPress,
    fiveColors,
    countBack,
  ];

  static const List<Tool> allTools = [
    ...kitTools,
    ...nearbyTools,
    ...noItemTools,
  ];

  /// Get tool by ID
  static Tool? getById(String id) {
    try {
      return allTools.firstWhere((tool) => tool.id == id);
    } catch (e) {
      return null;
    }
  }
}
