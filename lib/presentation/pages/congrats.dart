import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
          const Expanded(child: StarBadgeLottie()),
          Text(
            'Congrats!',
            style: textTheme.displayLarge?.copyWith(color: Colors.white),
          ),
          GapSizes.xsGap,
          Text(
            'You completed the Bonfire Crash Course!',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          GapSizes.xlGap,
          Text(
            'Learn more',
            style: textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
          GapSizes.smallGap,
          SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                AdaptiveButton(
                  child: const Text('Bonfire'),
                  onPressed: () async {
                    final uri = Uri.parse(
                      'https://bonfire-engine.github.io/#/',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                AdaptiveButton(
                  child: const Text('Flutter'),
                  onPressed: () async {
                    final uri = Uri.parse('https://flutter.dev/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                AdaptiveButton(
                  child: const Text('Dart'),
                  onPressed: () async {
                    final uri = Uri.parse('https://dart.dev/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
