/// Represents a key Bonfire engine or game development concept introduced in a lesson.
///
/// Used by lesson pages and presented via [AdaptiveCallout] widgets to provide
/// concise explanations of components, APIs, or architectural patterns.
class Concept {
  /// The name of the concept or API (e.g., "WorldMapByTiled", "Parallax Background").
  final String title;

  /// A brief explanation detailing what the concept is and how it functions in the engine.
  final String subtitle;

  /// Creates a new [Concept] definition.
  const Concept({required this.title, required this.subtitle});
}
