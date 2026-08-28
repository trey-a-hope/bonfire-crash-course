import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:flutter/widgets.dart';
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
    return PlatformResolver.isMacOS
        ? _buildMacOsButton()
        : _buildWindowsButton();
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
