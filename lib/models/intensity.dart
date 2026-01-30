/// Intensity levels for how strong the feeling is
enum Intensity {
  low('Low'),
  medium('Medium'),
  high('High'),
  notSure('Not sure');

  const Intensity(this.displayName);
  
  final String displayName;

  /// Check if this intensity level triggers safety check
  /// Per spec: (Panic/Anxiety or Numb) + High intensity → Safety Check
  bool get isHigh => this == Intensity.high;
}
