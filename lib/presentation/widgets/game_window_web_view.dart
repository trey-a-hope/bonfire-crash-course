part of 'game_window.dart';

/// The real web view: `flutter_inappwebview`, which runs on both macOS
/// (WKWebView) and Windows (WebView2).
Widget _inAppWebView(
  BuildContext context, {
  required Uri url,
  required VoidCallback onLoaded,
  required VoidCallback onError,
}) {
  final supported =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);
  if (!supported) {
    // flutter_inappwebview isn't set up here (Linux, web): go straight to the
    // error panel, which offers "Open in browser".
    WidgetsBinding.instance.addPostFrameCallback((_) => onError());
    return const SizedBox.shrink();
  }
  return InAppWebView(
    initialUrlRequest: URLRequest(url: WebUri.uri(url)),
    initialSettings: InAppWebViewSettings(
      transparentBackground: true,
      disableContextMenu: true,
      supportZoom: false,
    ),
    onLoadStop: (controller, _) => _waitForGame(controller, onLoaded),
    onReceivedError: (controller, request, error) {
      if (request.isForMainFrame ?? false) onError();
    },
    onReceivedHttpError: (controller, request, response) {
      if (request.isForMainFrame ?? false) onError();
    },
  );
}

/// The HTML loads before the Flutter web app inside it has started, so keep
/// the spinner up until its `flutter-view` exists (up to about 15 s), then
/// hand it keyboard focus, so A/D, Space, S and W reach the hero.
Future<void> _waitForGame(
  InAppWebViewController controller,
  VoidCallback onLoaded,
) async {
  const script =
      "(function () { var v = document.querySelector('flutter-view'); if (!v) { return false; } window.focus(); v.focus(); return true; })()";
  try {
    for (var i = 0; i < 60; i++) {
      if (await controller.evaluateJavascript(source: script) == true) break;
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  } catch (_) {
    // The web view was closed ("Try again", or the student left the page).
    return;
  }
  onLoaded();
}

Future<void> _launchInBrowser(Uri url) async {
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (_) {
    // Nothing more to offer if the system can't open a browser.
  }
}
