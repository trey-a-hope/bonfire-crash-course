import 'package:bonfire_crash_course/presentation/widgets/adaptive_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

/// Main entry page for displaying the application content.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentPageWidget();
  }
}

class ContentPageWidget extends StatelessWidget {
  const ContentPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveWindow();
  }
}
