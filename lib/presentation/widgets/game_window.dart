import 'dart:async';

import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds the web view that plays the game. [onLoaded] runs once the page has
/// finished loading, and [onError] runs if the page itself fails to load.
typedef GameWebViewBuilder =
    Widget Function(
      BuildContext context, {
      required Uri url,
      required VoidCallback onLoaded,
      required VoidCallback onError,
    });

/// What the [GameWindow] is showing.
enum GameWindowState { idle, loading, playing, error }

/// A small 16:9 window that plays the finished template game from its web
/// build ([TEMPLATE_GAME_URL]).
///
/// Nothing is loaded until the student clicks "Click to play", so the page
/// stays light. Then a spinner shows over the web view until the game has
/// loaded. If the page can't load, the window offers "Open in browser" and
/// "Try again". A controls hint and an "Open in browser" link sit underneath.
class GameWindow extends StatefulWidget {
  /// The game's web address.
  final Uri url;

  /// Builds the web view. Tests swap in a fake, since a real web view needs a
  /// platform view.
  final GameWebViewBuilder webViewBuilder;

  /// Opens [url] outside the app. Defaults to the system browser.
  final Future<void> Function(Uri url) openInBrowser;

  GameWindow({
    super.key,
    Uri? url,
    GameWebViewBuilder? webViewBuilder,
    Future<void> Function(Uri url)? openInBrowser,
  }) : url = url ?? Uri.parse(TEMPLATE_GAME_URL),
       webViewBuilder = webViewBuilder ?? _inAppWebView,
       openInBrowser = openInBrowser ?? _launchInBrowser;

  /// How long the window waits for the game before showing the error.
  static const loadTimeout = Duration(seconds: 30);

  /// The blue used for the play button, spinner and focus ring.
  static const accent = Colors.blueAccent;

  /// The window's background, behind the game.
  static const background = Color(0xFF0B0D12);

  @override
  State<GameWindow> createState() => _GameWindowState();
}

class _GameWindowState extends State<GameWindow> {
  GameWindowState _state = GameWindowState.idle;

  /// Bumped on "Try again", so a fresh web view is built.
  int _attempt = 0;

  /// Shows the error if the game hasn't loaded within [GameWindow.loadTimeout],
  /// for example when the web view never starts.
  Timer? _timeout;

  void _play() {
    _timeout?.cancel();
    _timeout = Timer(GameWindow.loadTimeout, _onError);
    setState(() {
      _state = GameWindowState.loading;
      _attempt++;
    });
  }

  void _onLoaded() {
    if (!mounted || _state != GameWindowState.loading) return;
    _timeout?.cancel();
    setState(() => _state = GameWindowState.playing);
  }

  /// Only a failure while loading counts: once the game is playing, a later
  /// error (a missing favicon, say) leaves it running.
  void _onError() {
    if (!mounted || _state != GameWindowState.loading) return;
    _timeout?.cancel();
    setState(() => _state = GameWindowState.error);
  }

  @override
  void dispose() {
    _timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final showWebView =
        _state == GameWindowState.loading || _state == GameWindowState.playing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: GameWindow.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _state == GameWindowState.playing
                    ? GameWindow.accent
                    : Colors.white.withValues(alpha: 0.12),
                width: _state == GameWindowState.playing ? 2 : 1,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (showWebView)
                  KeyedSubtree(
                    key: ValueKey(_attempt),
                    child: widget.webViewBuilder(
                      context,
                      url: widget.url,
                      onLoaded: _onLoaded,
                      onError: _onError,
                    ),
                  ),
                if (_state == GameWindowState.idle) _Idle(onPlay: _play),
                if (_state == GameWindowState.loading) const _Loading(),
                if (_state == GameWindowState.error)
                  _Error(
                    onOpenInBrowser: () => widget.openInBrowser(widget.url),
                    onTryAgain: _play,
                  ),
              ],
            ),
          ),
        ),
        GapSizes.smallGap,
        // The error panel has its own "Open in browser", so the link hides.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              'A/D walk · Space jump · S melee · W magic bolt',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            if (_state != GameWindowState.error)
              TextButton.icon(
                onPressed: () => widget.openInBrowser(widget.url),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: const Text('Open in browser'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent[100],
                  textStyle: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Idle extends StatelessWidget {
  final VoidCallback onPlay;

  const _Idle({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A3142), Color(0xFF161A24), GameWindow.background],
          stops: [0, 0.6, 1],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Click to play the template game',
              child: Material(
                color: GameWindow.accent.withValues(alpha: 0.3),
                shape: CircleBorder(
                  side: BorderSide(
                    color: GameWindow.accent.withValues(alpha: 0.6),
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPlay,
                  child: const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
            ),
            GapSizes.smallGap,
            Text(
              'Click to play',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The finished template game, live in this window',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GameWindow.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: GameWindow.accent,
              ),
            ),
            GapSizes.smallGap,
            Text(
              'Loading the game…',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final VoidCallback onOpenInBrowser;
  final VoidCallback onTryAgain;

  const _Error({required this.onOpenInBrowser, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: GameWindow.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              GapSizes.smallGap,
              Text(
                "Couldn't load the game",
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check your connection, or play it in your browser.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              GapSizes.smallGap,
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: onOpenInBrowser,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: GameWindow.accent.withValues(
                        alpha: 0.25,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Open in browser'),
                  ),
                  OutlinedButton(
                    onPressed: onTryAgain,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
