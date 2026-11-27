import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// Plays the hosted starter game inside the app with an embedded web view.
///
/// Uses the official `webview_flutter` plugin, which embeds the page on
/// Android, iOS and macOS. A spinner shows until the page finishes loading.
///
/// `webview_flutter` has no Windows, Linux or web implementation, so on those
/// targets a "Play in browser" card opens the game in the default browser
/// instead.
class WebGameView extends StatelessWidget {
  static const String defaultUrl =
      'https://bonfire-crash-course-template.codemagic.app/';

  final String url;
  final double aspectRatio;
  final BorderRadius borderRadius;

  const WebGameView({
    super.key,
    this.url = defaultUrl,
    this.aspectRatio = 16 / 9,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  /// Whether `webview_flutter` can embed a page on the current target.
  static bool get supportsEmbedding =>
      !kIsWeb &&
      (PlatformResolver.isAndroid ||
          PlatformResolver.isIos ||
          PlatformResolver.isMacOS);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: supportsEmbedding
            ? _EmbeddedGame(url: url)
            : _OpenInBrowser(url: url),
      ),
    );
  }
}

class _EmbeddedGame extends StatefulWidget {
  final String url;

  const _EmbeddedGame({required this.url});

  @override
  State<_EmbeddedGame> createState() => _EmbeddedGameState();
}

class _EmbeddedGameState extends State<_EmbeddedGame> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // Let the game's audio and video start without a tap, and play inline
    // rather than full screen on iOS.
    final PlatformWebViewControllerCreationParams params =
        WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      );

    // Background colour and zoom are not implemented on macOS.
    if (!PlatformResolver.isMacOS) {
      controller
        ..setBackgroundColor(Colors.transparent)
        ..enableZoom(false);
    }

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }

    controller.loadRequest(Uri.parse(widget.url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const ColoredBox(
            color: Colors.black,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _OpenInBrowser extends StatelessWidget {
  final String url;

  const _OpenInBrowser({required this.url});

  Future<void> _open() async {
    final uri = Uri.parse(url);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) debugPrint('Could not open $uri');
    } on PlatformException catch (error) {
      debugPrint('Could not open $uri: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: FilledButton.icon(
          onPressed: _open,
          icon: const Icon(Icons.sports_esports_rounded),
          label: const Text('Play in browser'),
        ),
      ),
    );
  }
}
