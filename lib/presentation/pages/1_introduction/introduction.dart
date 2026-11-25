import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/rive/bird_rive_animation.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:video_player/video_player.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  VideoPlayerController? _controller;

  static const String _localVideoAsset = 'assets/videos/flight.mp4';
  static const String _remoteVideoUrl =
      'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4';

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    VideoPlayerController? controller;

    final local = VideoPlayerController.asset(_localVideoAsset);
    try {
      await local.initialize();
      controller = local;
    } catch (_) {
      await local.dispose();
    }

    if (controller == null && mounted) {
      final remote = VideoPlayerController.networkUrl(
        Uri.parse(_remoteVideoUrl),
      );
      try {
        await remote.initialize();
        controller = remote;
      } catch (_) {
        await remote.dispose();
      }
    }

    if (controller == null) return;

    if (!mounted) {
      await controller.dispose();
      return;
    }

    _controller = controller;
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.play();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full background video without player controls
            if (_controller case final controller?
                when controller.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: controller.value.size.width > 0
                      ? controller.value.size.width
                      : 1920,
                  height: controller.value.size.height > 0
                      ? controller.value.size.height
                      : 1080,
                  child: VideoPlayer(controller),
                ),
              )
            else
              const ColoredBox(color: Colors.black),

            // Dark opacity overlay to make the text pop
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.40),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),

            // Centered Hero Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Rive bird (tap it to startle). The artboard has
                    // its own sky background, so frame it like a small window.
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: const BirdRiveAnimation(
                          width: 240,
                          height: 180,
                          expression: BirdExpression.blink,
                        ),
                      ),
                    ),
                    GapSizes.mediumGap,

                    // Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blueAccent.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.orangeAccent,
                            size: 16,
                          ),
                          GapSizes.smallGap,
                          Text(
                            'FLUTTER & FLAME ENGINE',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GapSizes.largeGap,

                    // Main Title
                    Text(
                      'Bonfire Crash Course',
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    GapSizes.smallGap,

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        'Build modern 2D RPG games in Flutter with the power of the Bonfire framework',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GapSizes.mediumGap,
                    GlassButton(
                      title: 'Get Started',
                      onPressed: () =>
                          ProgressNavigationController.next(context),
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
