/// Represents a key Bonfire engine or game development concept introduced in a lesson.
///
/// Coding lessons show each concept as a chip above the code. Tapping the chip
/// shows [short] and lights up the code lines that contain [codeMatch];
/// "Learn more" reveals the full [subtitle].
class Concept {
  /// The name of the concept or API (e.g., "WorldMapByTiled", "Parallax Background").
  final String title;

  /// A brief explanation detailing what the concept is and how it functions in the engine.
  final String subtitle;

  /// What the concept does, in one short line.
  final String short;

  /// Text that marks the concept's lines in the lesson's code, such as
  /// `'CameraConfig('`. Every line containing it is highlighted when the
  /// concept is picked. Null when the concept has no single line to point at.
  final String? codeMatch;

  /// Creates a new [Concept] definition.
  const Concept({
    required this.title,
    required this.subtitle,
    required this.short,
    this.codeMatch,
  });
}
