part of 'getting_started_rive.dart';

/// Shown in place of a Getting Started animation whose file couldn't load.
class _GettingStartedRiveFallback extends StatelessWidget {
  final GettingStartedScene scene;

  const _GettingStartedRiveFallback({required this.scene});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        scene.fallbackIcon,
        key: const ValueKey('getting-started-rive-fallback'),
        size: 72,
        color: Colors.lightGreenAccent.withValues(alpha: 0.8),
      ),
    );
  }
}
