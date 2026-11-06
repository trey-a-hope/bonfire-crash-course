part of 'onboarding.dart';

/// The big 16:9 card at the top of a Getting Started page that plays the
/// lesson's Rive animation.
class AnimatedHeroCard extends StatelessWidget {
  /// Which animation to play.
  final GettingStartedScene scene;

  const AnimatedHeroCard({super.key, required this.scene});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: scene.semanticLabel,
      image: true,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: onboardingCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ExcludeSemantics(child: GettingStartedRive(scene: scene)),
        ),
      ),
    );
  }
}
