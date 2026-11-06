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
    // No initial URL: the game is loaded by [_loadWhenSized] once the web
    // view has a size.
    initialSettings: InAppWebViewSettings(
      disableContextMenu: true,
      supportZoom: false,
      // The game starts on its own, so let its sound play without a click.
      mediaPlaybackRequiresUserGesture: false,
      // In debug builds, Safari's Develop menu (macOS) or Edge DevTools
      // (Windows) can inspect the game page.
      isInspectable: kDebugMode,
    ),
    // The web view keeps the mouse wheel for itself, so the page wouldn't
    // scroll while the pointer is over the game. Pass the wheel back to it.
    initialUserScripts: UnmodifiableListView([
      UserScript(
        source: _forwardWheelScript,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      ),
    ]),
    onWebViewCreated: (controller) {
      controller.addJavaScriptHandler(
        handlerName: _wheelHandler,
        callback: (args) {
          final dy = args.isEmpty ? null : args.first;
          if (dy is! num || !context.mounted) return;
          final position = Scrollable.maybeOf(context)?.position;
          if (position is ScrollPositionWithSingleContext) {
            position.pointerScroll(dy.toDouble());
          }
        },
      );
      _loadWhenSized(controller, url);
    },
    onLoadStop: (controller, loaded) {
      // Skip the blank page the web view starts on.
      if (loaded?.host != url.host) return;
      _waitForGame(controller, onLoaded: onLoaded, onError: onError);
    },
    onConsoleMessage: (controller, message) {
      if (kDebugMode) debugPrint('[GameWindow] ${message.message}');
    },
    onReceivedError: (controller, request, error) {
      if (request.isForMainFrame ?? false) onError();
    },
    onReceivedHttpError: (controller, request, response) {
      if (request.isForMainFrame ?? false) onError();
    },
  );
}

/// The name the page uses to send wheel scrolls back to the app.
const _wheelHandler = 'gameWindowWheel';

/// Sends every vertical wheel scroll on the game page to [_wheelHandler].
const _forwardWheelScript =
    "window.addEventListener('wheel', function (e) { if (window.flutter_inappwebview && e.deltaY) { window.flutter_inappwebview.callHandler('$_wheelHandler', e.deltaY); } }, { capture: true, passive: true });";

/// Loads the game once the web view has been laid out.
///
/// The web view starts at 0×0 until Flutter places it. A game started then
/// fits its camera to a zero-height screen and crashes ("NaN.floor()"), which
/// leaves the window black. So wait (up to about 5 s) until the page reports a
/// real size before loading the game.
Future<void> _loadWhenSized(InAppWebViewController controller, Uri url) async {
  const script = 'window.innerWidth > 0 && window.innerHeight > 0';
  try {
    for (var i = 0; i < 50; i++) {
      final sized = await controller.evaluateJavascript(source: script);
      if (sized == true || sized == 1) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    await controller.loadUrl(urlRequest: URLRequest(url: WebUri.uri(url)));
  } catch (_) {
    // The web view was closed before the game loaded.
  }
}

/// The HTML loads before the Flutter web app inside it has started, so keep
/// the spinner up until its `flutter-view` exists (up to about 20 s), then
/// hand it keyboard focus, so A/D, Space, S and W reach the hero. If it never
/// appears, show the error panel rather than an empty window.
Future<void> _waitForGame(
  InAppWebViewController controller, {
  required VoidCallback onLoaded,
  required VoidCallback onError,
}) async {
  const script =
      "(function () { var v = document.querySelector('flutter-view'); if (!v) { return false; } window.focus(); v.focus(); return true; })()";
  try {
    for (var i = 0; i < 80; i++) {
      final found = await controller.evaluateJavascript(source: script);
      // WKWebView can hand a JS true back as 1.
      if (found == true || found == 1) {
        onLoaded();
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  } catch (_) {
    // The web view was closed (the student left the page, or "Try again").
    return;
  }
  onError();
}

Future<void> _launchInBrowser(Uri url) async {
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (_) {
    // Nothing more to offer if the system can't open a browser.
  }
}
