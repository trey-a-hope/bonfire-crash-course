import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

/// Shown instead of the app on phones whose screen is too narrow for the
/// course layout (for example, a normal, non-folding phone).
///
/// Foldables unfolded and tablets are wide enough, so they never see this page.
class UnsupportedDevicePage extends StatelessWidget {
  const UnsupportedDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFF1B1B1E),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.devices_rounded,
                    size: 64,
                    color: Colors.orangeAccent,
                  ),
                  const Gap(24),
                  Text(
                    'This course needs a bigger screen',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Open it on a tablet or on a foldable phone that is unfolded.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
