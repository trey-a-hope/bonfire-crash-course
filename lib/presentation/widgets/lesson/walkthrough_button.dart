part of 'lesson.dart';

/// Opens the lesson's video walkthrough in a large player, on demand.
class WalkthroughButton extends StatelessWidget {
  /// The video to play.
  final String videoUrl;

  /// The title shown on the player.
  final String title;

  const WalkthroughButton({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => CourseVideoPlayer.showModal(
        context,
        videoUrl: videoUrl,
        title: title,
        autoplay: true,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 40),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.play_arrow_rounded, size: 18),
      label: const Text('Watch the walkthrough'),
    );
  }
}
