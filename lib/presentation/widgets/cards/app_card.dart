import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:material_ui/material_ui.dart';

enum CardType {
  info(color: Colors.cyanAccent, icon: Icons.info),
  action(color: Colors.orangeAccent, icon: Icons.local_fire_department_rounded),
  objective(color: Colors.blueAccent, icon: Icons.flag),
  lightbulb(color: Colors.amberAccent, icon: Icons.lightbulb),
  error(color: Colors.redAccent, icon: Icons.error);

  final Color color;
  final IconData icon;

  const CardType({required this.color, required this.icon});
}

class AppCard extends StatelessWidget {
  final String title;
  final String description;
  final CardType type;
  final IconData? iconOverride;

  const AppCard({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    this.iconOverride,
  });

  // Named factory constructors for a clean call site
  factory AppCard.info({
    Key? key,
    required String title,
    required String description,
    IconData? icon,
  }) => AppCard(
    key: key,
    title: title,
    description: description,
    type: CardType.info,
    iconOverride: icon,
  );

  factory AppCard.action({
    Key? key,
    required String title,
    required String description,
    IconData? icon,
  }) => AppCard(
    key: key,
    title: title,
    description: description,
    type: CardType.action,
    iconOverride: icon,
  );

  factory AppCard.objective({
    Key? key,
    required String title,
    required String description,
    IconData? icon,
  }) => AppCard(
    key: key,
    title: title,
    description: description,
    type: CardType.objective,
    iconOverride: icon,
  );

  factory AppCard.lightbulb({
    Key? key,
    required String title,
    required String description,
    IconData? icon,
  }) => AppCard(
    key: key,
    title: title,
    description: description,
    type: CardType.lightbulb,
    iconOverride: icon,
  );

  factory AppCard.error({
    Key? key,
    required String title,
    required String description,
    IconData? icon,
  }) => AppCard(
    key: key,
    title: title,
    description: description,
    type: CardType.error,
    iconOverride: icon,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentColor = type.color;
    final cardIcon = iconOverride ?? type.icon;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(cardIcon, color: accentColor, size: 22),
          ),
          GapSizes.mediumGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GapSizes.xsGap,
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
