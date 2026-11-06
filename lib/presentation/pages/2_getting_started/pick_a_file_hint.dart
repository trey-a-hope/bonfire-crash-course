part of 'project_file_structure.dart';

/// The folder animation and a nudge, shown until a file is picked.
class _PickAFileHint extends StatelessWidget {
  const _PickAFileHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AnimatedHeroCard(scene: GettingStartedScene.fileStructure),
        GapSizes.mediumGap,
        Text(
          'Tap a file to see what it does',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
