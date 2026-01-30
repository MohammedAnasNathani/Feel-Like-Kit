/// Feeling/Emotion types that users can select
enum Feeling {
  panicAnxiety('Panic/Anxiety', '😟'),
  overwhelmed('Overwhelmed', '📚'),
  sad('Sad', '😢'),
  angry('Angry', '😠'),
  numb('Numb', '😐'),
  notSure('Not Sure', '❓');

  const Feeling(this.displayName, this.emoji);
  
  final String displayName;
  final String emoji;

  /// Check if this feeling triggers the safety check
  /// Per spec: Panic/Anxiety or Numb + High intensity → Safety Check
  bool get triggersSafetyCheck {
    return this == Feeling.panicAnxiety || this == Feeling.numb;
  }
}
