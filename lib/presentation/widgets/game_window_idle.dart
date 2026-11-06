part of 'game_window.dart';

/// The "Click to play" cover shown before the game loads.
class _Idle extends StatelessWidget {
  final VoidCallback onPlay;

  const _Idle({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A3142), Color(0xFF161A24), GameWindow.background],
          stops: [0, 0.6, 1],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Click to play the template game',
              child: Material(
                color: GameWindow.accent.withValues(alpha: 0.3),
                shape: CircleBorder(
                  side: BorderSide(
                    color: GameWindow.accent.withValues(alpha: 0.6),
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPlay,
                  child: const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
            ),
            GapSizes.smallGap,
            Text(
              'Click to play',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The finished template game, live in this window',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
