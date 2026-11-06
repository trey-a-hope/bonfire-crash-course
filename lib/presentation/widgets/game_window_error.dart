part of 'game_window.dart';

/// The panel shown when the game can't load, with "Open in browser" and
/// "Try again".
class _Error extends StatelessWidget {
  final VoidCallback onOpenInBrowser;
  final VoidCallback onTryAgain;

  const _Error({required this.onOpenInBrowser, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: GameWindow.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              GapSizes.smallGap,
              Text(
                "Couldn't load the game",
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check your connection, or play it in your browser.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              GapSizes.smallGap,
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: onOpenInBrowser,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: GameWindow.accent.withValues(
                        alpha: 0.25,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Open in browser'),
                  ),
                  OutlinedButton(
                    onPressed: onTryAgain,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
