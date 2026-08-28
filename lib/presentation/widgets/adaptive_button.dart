import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Aliased imports to avoid name collisions
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as mac;

enum AdaptiveButtonType { regular, filled }

class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final AdaptiveButtonType type;

  const AdaptiveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.type = AdaptiveButtonType.regular,
  });

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return _buildMacOsButton();
      case TargetPlatform.windows:
        return _buildWindowsButton();
      default:
        return _buildWindowsButton();
    }
  }

  Widget _buildWindowsButton() {
    if (type == AdaptiveButtonType.filled) {
      return fluent.FilledButton(onPressed: onPressed, child: child);
    }
    return fluent.Button(onPressed: onPressed, child: child);
  }

  Widget _buildMacOsButton() {
    return mac.PushButton(
      controlSize: mac.ControlSize.regular,
      secondary: type == AdaptiveButtonType.regular,
      onPressed: onPressed,
      child: child,
    );
  }
}
