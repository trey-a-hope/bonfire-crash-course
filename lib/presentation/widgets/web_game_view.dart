import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_ui/material_ui.dart';

/// Plays the hosted starter game inside the app with an embedded web view.
///
/// Uses `flutter_inappwebview`, which supports macOS, Windows (WebView2),
/// iOS and Android. A spinner shows until the first frame of the page loads.
class WebGameView extends StatefulWidget {
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

  @override
  State<WebGameView> createState() => _WebGameViewState();
}

class _WebGameViewState extends State<WebGameView> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                disableContextMenu: true,
                supportZoom: false,
              ),
              onLoadStop: (_, _) {
                if (mounted) setState(() => _loading = false);
              },
            ),
            if (_loading)
              const ColoredBox(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
