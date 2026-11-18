import 'dart:ui';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/settings_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final Object? heroTag;
  final VoidCallback? onToggleExpand;
  final bool isExpanded;
  final Duration? initialPosition;
  final bool autoplay;

  const CourseVideoPlayer({
    super.key,
    required this.videoUrl,
    this.title = 'Course Video',
    this.heroTag,
    this.onToggleExpand,
    this.isExpanded = false,
    this.initialPosition,
    this.autoplay = false,
  });

  /// Opens the [CourseVideoPlayer] inside an enlarged modal dialog with Hero animation.
  static Future<Duration?> showModal(
    BuildContext context, {
    required String videoUrl,
    String title = 'Course Video',
    Object? heroTag,
    Duration? initialPosition,
    bool autoplay = false,
  }) {
    final effectiveHeroTag = heroTag ?? UniqueKey();

    return Navigator.of(context, rootNavigator: true).push<Duration>(
      PageRouteBuilder<Duration>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return CourseVideoModalDialog(
            videoUrl: videoUrl,
            title: title,
            heroTag: effectiveHeroTag,
            initialPosition: initialPosition,
            autoplay: autoplay,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  final _player = Player();
  late final _controller = VideoController(_player);
  bool _isHovered = false;

  late final Object _effectiveHeroTag = widget.heroTag ?? UniqueKey();

  @override
  void initState() {
    super.initState();
    _player.setPlaylistMode(PlaylistMode.single);
    // media_kit volume ranges from 0 to 100
    _player.setVolume(SettingsController.volume.value * 100);
    _player.open(Media(widget.videoUrl), play: widget.autoplay);
    if (widget.initialPosition != null &&
        widget.initialPosition! > Duration.zero) {
      _player.seek(widget.initialPosition!);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _handleExpand() async {
    if (widget.onToggleExpand != null) {
      widget.onToggleExpand!();
      return;
    }
    await _openModal();
  }

  Future<void> _openModal() async {
    final wasPlaying = _player.state.playing;
    final currentPos = _player.state.position;
    if (wasPlaying) {
      await _player.pause();
    }

    if (!mounted) return;

    final returnedPos = await CourseVideoPlayer.showModal(
      context,
      videoUrl: widget.videoUrl,
      title: widget.title,
      heroTag: _effectiveHeroTag,
      initialPosition: currentPos,
      autoplay: wasPlaying,
    );

    if (returnedPos != null && mounted) {
      await _player.seek(returnedPos);
      if (wasPlaying) {
        await _player.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomControls = [
      const MaterialPlayOrPauseButton(),
      const MaterialPositionIndicator(),
      const Spacer(),
      const MaterialDesktopVolumeButton(),
      MaterialCustomButton(
        onPressed: _handleExpand,
        icon: Icon(
          widget.isExpanded
              ? Icons.fullscreen_exit_rounded
              : Icons.fullscreen_rounded,
          color: Colors.white,
        ),
      ),
    ];

    Widget playerWidget = AspectRatio(
      aspectRatio: 16 / 9,
      child: MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(bottomButtonBar: bottomControls),
        fullscreen: MaterialVideoControlsThemeData(
          bottomButtonBar: bottomControls,
        ),
        child: Video(controller: _controller, controls: MaterialVideoControls),
      ),
    );

    if (widget.isExpanded) {
      return playerWidget;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Hero(
        tag: _effectiveHeroTag,
        flightShuttleBuilder: _flightShuttleBuilder,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? Colors.blueAccent.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.12),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.25),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Stack(
              alignment: Alignment.center,
              children: [
                playerWidget,
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.75),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _openModal,
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.blueAccent,
            size: 48,
          ),
        ),
      ),
    );
  }
}

class CourseVideoModalDialog extends StatefulWidget {
  final String videoUrl;
  final String title;
  final Object heroTag;
  final Duration? initialPosition;
  final bool autoplay;

  const CourseVideoModalDialog({
    super.key,
    required this.videoUrl,
    this.title = 'Course Video',
    required this.heroTag,
    this.initialPosition,
    this.autoplay = false,
  });

  @override
  State<CourseVideoModalDialog> createState() => _CourseVideoModalDialogState();
}

class _CourseVideoModalDialogState extends State<CourseVideoModalDialog> {
  bool _isExpanded = false;
  final GlobalKey<_CourseVideoPlayerState> _playerKey =
      GlobalKey<_CourseVideoPlayerState>();

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _close() {
    final pos = _playerKey.currentState?._player.state.position;
    Navigator.of(context).pop(pos);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);

    final maxWidth = _isExpanded ? screenSize.width * 0.95 : 920.0;
    final maxHeight = _isExpanded
        ? screenSize.height * 0.95
        : screenSize.height * 0.85;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Tap backdrop to dismiss
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _close,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.82),
                    ),
                  ),
                ),
              ),
              // Center modal card
              Center(
                child: Hero(
                  tag: widget.heroTag,
                  flightShuttleBuilder:
                      (
                        flightContext,
                        animation,
                        flightDirection,
                        fromHeroContext,
                        toHeroContext,
                      ) {
                        return Material(
                          type: MaterialType.transparency,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2C),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blueAccent.withValues(alpha: 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.blueAccent,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 32,
                          spreadRadius: 4,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Modal Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.blueAccent,
                                  size: 24,
                                ),
                                GapSizes.smallGap,
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isExpanded
                                        ? Icons.fullscreen_exit_rounded
                                        : Icons.fullscreen_rounded,
                                    color: Colors.white70,
                                  ),
                                  tooltip: _isExpanded ? 'Restore' : 'Expand',
                                  onPressed: _toggleExpand,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white70,
                                  ),
                                  tooltip: 'Close (Esc)',
                                  onPressed: _close,
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: Colors.white12),
                          // Video Player Body
                          Flexible(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: CourseVideoPlayer(
                                key: _playerKey,
                                videoUrl: widget.videoUrl,
                                title: widget.title,
                                onToggleExpand: _toggleExpand,
                                isExpanded: true,
                                initialPosition: widget.initialPosition,
                                autoplay: widget.autoplay,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
