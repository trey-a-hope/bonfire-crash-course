import 'dart:async';

import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'game_window_error.dart';
part 'game_window_loading.dart';
part 'game_window_web_view.dart';

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
enum GameWindowState { loading, playing, error }

/// A 16:9 window that plays the finished template game from its web build
/// ([TEMPLATE_GAME_URL]).
///
/// The game starts loading as soon as the window opens, with a spinner over
/// the web view until it has loaded. If the page can't load, the window offers "Open in browser" and
/// "Try again". A controls hint and an "Open in browser" link sit underneath.
class GameWindow extends SignalStatefulWidget {
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

  /// The blue used for the spinner and focus ring.
  static const accent = Colors.blueAccent;

  /// The window's background, behind the game.
  static const background = Color(0xFF0B0D12);

  @override
  State<GameWindow> createState() => _GameWindowState();
}

class _GameWindowState extends State<GameWindow> {
  /// What the window is showing. Reading it in [build] rebuilds the window
  /// whenever it changes.
  final _state = Signal<GameWindowState>(GameWindowState.loading);

  /// Bumped on "Try again", so a fresh web view is built.
  final _attempt = Signal<int>(0);

  /// Shows the error if the game hasn't loaded within [GameWindow.loadTimeout],
  /// for example when the web view never starts.
  Timer? _timeout;

  @override
  void initState() {
    super.initState();
    // The game starts as soon as the page opens.
    _play();
  }

  void _play() {
    _timeout?.cancel();
    _timeout = Timer(GameWindow.loadTimeout, _onError);
    batch(() {
      _state.value = GameWindowState.loading;
      _attempt.value++;
    });
  }

  void _onLoaded() {
    if (!mounted || _state.value != GameWindowState.loading) return;
    _timeout?.cancel();
    _state.value = GameWindowState.playing;
  }

  /// Only a failure while loading counts: once the game is playing, a later
  /// error (a missing favicon, say) leaves it running.
  void _onError() {
    if (!mounted || _state.value != GameWindowState.loading) return;
    _timeout?.cancel();
    _state.value = GameWindowState.error;
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _state.dispose();
    _attempt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = _state.value;
    final showWebView =
        state == GameWindowState.loading || state == GameWindowState.playing;

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
                color: state == GameWindowState.playing
                    ? GameWindow.accent
                    : Colors.white.withValues(alpha: 0.12),
                width: state == GameWindowState.playing ? 2 : 1,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (showWebView)
                  KeyedSubtree(
                    key: ValueKey(_attempt.value),
                    child: widget.webViewBuilder(
                      context,
                      url: widget.url,
                      onLoaded: _onLoaded,
                      onError: _onError,
                    ),
                  ),
                if (state == GameWindowState.loading) const _Loading(),
                if (state == GameWindowState.error)
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
            if (state != GameWindowState.error)
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
