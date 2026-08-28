import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:flutter/widgets.dart';

/// Main entry page for displaying the application content.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Renders a platform-adaptive button centered on the page
      child: AdaptiveButton(
        child: const Text('Hello'),
        onPressed: () {
          debugPrint('Button clicked');
        },
      ),
    );
  }
}
