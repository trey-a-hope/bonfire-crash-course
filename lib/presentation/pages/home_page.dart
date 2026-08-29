import 'package:bonfire_crash_course/domain/models/pane_info.dart';
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
    return AdaptiveWindow(
      panes: [
        PaneInfo(
          icon: Icon(Icons.settings),
          child: Placeholder(color: Colors.green),
          title: 'Green',
        ),
        PaneInfo(
          icon: Icon(Icons.house),
          child: Placeholder(color: Colors.red),
          title: 'Red',
        ),
        PaneInfo(
          icon: Icon(Icons.account_balance),
          child: Placeholder(color: Colors.blue),
          title: 'Blue',
        ),
      ],
    );
  }
}
