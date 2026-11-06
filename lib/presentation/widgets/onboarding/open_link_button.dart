part of 'onboarding.dart';

/// The page's one main button. It opens [url] in the default browser.
class OpenLinkButton extends StatelessWidget {
  /// The button's label.
  final String title;

  /// Where the button goes.
  final String url;

  /// The icon before the label.
  final IconData icon;

  /// The button's colour.
  final Color color;

  /// Opens the link. Tests swap in a fake.
  final Future<void> Function(Uri uri) openUrl;

  const OpenLinkButton({
    super.key,
    required this.title,
    required this.url,
    this.icon = Icons.open_in_new_rounded,
    this.color = Colors.purpleAccent,
    this.openUrl = _launch,
  });

  static Future<void> _launch(Uri uri) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) debugPrint('Could not open $uri');
    } on PlatformException catch (error) {
      debugPrint('Could not open $uri: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GlassButton(
        title: title,
        prefixIconData: icon,
        color: color,
        onPressed: () => openUrl(Uri.parse(url)),
      ),
    );
  }
}
