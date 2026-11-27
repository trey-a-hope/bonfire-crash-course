part of 'content_outline_view.dart';

/// The rounded, accent-tinted "MODULE N" label at the top of each
/// [_ContentOutlineSection], in the same style as the lesson step badges.
class _ModulePill extends StatelessWidget {
  /// The pill's text, e.g. 'MODULE 3'.
  final String label;

  /// Icon shown before the label.
  final IconData icon;

  /// Tints the pill's fill, border, icon and text.
  final Color accentColor;

  /// Creates a module pill.
  const _ModulePill({
    required this.label,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 15),
          GapSizes.smallGap,
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
