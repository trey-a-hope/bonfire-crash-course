import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/page_index_controller.dart';
import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:bonfire_crash_course/presentation/lotties/flutter_lottie.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const Expanded(
          child: Row(
            children: [
              Expanded(child: FlutterLottie(height: double.infinity)),
              Expanded(child: BonfireLottie(height: double.infinity)),
            ],
          ),
        ),
        Text(
          'Bonfire Crash Course',
          style: textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        GapSizes.xsGap,
        Text(
          'Learn how to build RPG games in Flutter',
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        GapSizes.xlGap,
        AdaptiveButton(
          onPressed: () => PageIndexController.increment(),
          type: AdaptiveButtonType.filled,
          child: const Text('Get Started'),
        ),
      ],
    );
  }
}
