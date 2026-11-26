import 'dart:async';
import 'dart:ui';

import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/settings_controller.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _controller;
  int _initToken = 0;
  bool _isInitializing = true;
  String? _errorMessage;

  bool _isHovered = false;
  bool _isControlsVisible = true;
  bool _isHoveringControls = false;
  Timer? _hideControlsTimer;

  double _volume = SettingsController.volume.value;
  double _volumeBeforeMute = SettingsController.volume.value > 0
      ? SettingsController.volume.value
      : SettingsController.defaultVolume;
  double? _scrubPositionMs;

  late final Object _effectiveHeroTag = widget.heroTag ?? UniqueKey();

  Duration? get currentPosition => _controller?.value.position;

  @override
  void initState() {
    super.initState();
    _initController(
      initialPosition: widget.initialPosition,
      autoplay: widget.autoplay,
    );
  }

  @override
  void didUpdateWidget(covariant CourseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initController(
        initialPosition: widget.initialPosition,
        autoplay: widget.autoplay,
      );
    }
  }

  VideoPlayerController _createController(String url) {
    if (url.startsWith('asset:///')) {
      return VideoPlayerController.asset(url.substring('asset:///'.length));
    }
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return VideoPlayerController.networkUrl(uri);
    }
    return VideoPlayerController.asset(url);
  }

  Future<void> _initController({
    Duration? initialPosition,
    bool autoplay = false,
  }) async {
    final token = ++_initToken;
    _hideControlsTimer?.cancel();
    final previous = _controller;
    _controller = null;
    await previous?.dispose();

    if (!mounted || token != _initToken) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
      _scrubPositionMs = null;
      _isControlsVisible = true;
    });

    final controller = _createController(widget.videoUrl);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(_volume);
      if (initialPosition != null && initialPosition > Duration.zero) {
        await controller.seekTo(initialPosition);
      }
      if (autoplay) {
        await controller.play();
      }

      if (!mounted || token != _initToken) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });

      if (autoplay) {
        _scheduleHideControls();
      }
    } catch (error) {
      await controller.dispose();
      if (!mounted || token != _initToken) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _showControlsTemporarily() {
    if (!_isControlsVisible) {
      setState(() => _isControlsVisible = true);
    }
    _scheduleHideControls();
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    if (_isHoveringControls || _scrubPositionMs != null) return;
    final isPlaying = _controller?.value.isPlaying ?? false;
    if (!isPlaying) return;

    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _isHoveringControls || _scrubPositionMs != null) return;
      if (_controller?.value.isPlaying ?? false) {
        setState(() => _isControlsVisible = false);
      }
    });
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
      _hideControlsTimer?.cancel();
      if (mounted) {
        setState(() => _isControlsVisible = true);
      }
    } else {
      await controller.play();
      _scheduleHideControls();
    }
  }

  Future<void> _setVolume(double value) async {
    final clamped = value.clamp(0.0, 1.0);
    setState(() {
      _volume = clamped;
      if (clamped > 0) {
        _volumeBeforeMute = clamped;
      }
    });
    await _controller?.setVolume(clamped);
  }

  Future<void> _toggleMute() async {
    if (_volume > 0) {
      _volumeBeforeMute = _volume;
      await _setVolume(0);
    } else {
      await _setVolume(_volumeBeforeMute > 0 ? _volumeBeforeMute : 0.8);
    }
  }

  Future<void> _handleExpand() async {
    if (widget.onToggleExpand != null) {
      widget.onToggleExpand!();
      return;
    }
    await _openModal();
  }

  Future<void> _openModal() async {
    final controller = _controller;
    final wasPlaying = controller?.value.isPlaying ?? false;
    final currentPos = controller?.value.position ?? Duration.zero;
    if (wasPlaying) {
      await controller?.pause();
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

    final activeController = _controller;
    if (returnedPos != null &&
        mounted &&
        activeController != null &&
        activeController.value.isInitialized) {
      await activeController.seekTo(returnedPos);
      if (wasPlaying) {
        await activeController.play();
        _scheduleHideControls();
      }
    }
  }

  static String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds.clamp(0, 359999);
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = hours > 0 ? minutes.toString().padLeft(2, '0') : '$minutes';
    final ss = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  Widget _buildVideoSurface() {
    final controller = _controller;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: MouseRegion(
          onHover: (_) => _showControlsTemporarily(),
          onExit: (_) => _scheduleHideControls(),
          child: controller == null
              ? _buildStateOverlay(
                  isLoading: _isInitializing,
                  errorText: _errorMessage,
                )
              : ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    if (value.hasError) {
                      return _buildStateOverlay(
                        isLoading: false,
                        errorText:
                            value.errorDescription ?? 'Unable to play video.',
                      );
                    }

                    final isInitialized = value.isInitialized;
                    final isPlaying = value.isPlaying;
                    final showControls = _isControlsVisible || !isPlaying;
                    final videoAspect = value.aspectRatio > 0
                        ? value.aspectRatio
                        : 16 / 9;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (isInitialized)
                          Center(
                            child: AspectRatio(
                              aspectRatio: videoAspect,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        // Tap video surface to toggle play/pause
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _togglePlayPause,
                          ),
                        ),
                        // Center play button or buffering spinner
                        if (!isInitialized || value.isBuffering)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          )
                        else if (!isPlaying)
                          Center(
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        // Bottom controls bar
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            ignoring: !showControls,
                            child: AnimatedOpacity(
                              opacity: showControls ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              child: MouseRegion(
                                onEnter: (_) {
                                  _isHoveringControls = true;
                                  _hideControlsTimer?.cancel();
                                },
                                onExit: (_) {
                                  _isHoveringControls = false;
                                  _scheduleHideControls();
                                },
                                child: _buildControlsBar(controller, value),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildStateOverlay({required bool isLoading, String? errorText}) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 36,
            ),
            GapSizes.smallGap,
            Text(
              'Unable to load video',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (errorText != null) ...[
              GapSizes.xsGap,
              Text(
                errorText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
            GapSizes.smallGap,
            TextButton.icon(
              onPressed: () => _initController(
                initialPosition: widget.initialPosition,
                autoplay: widget.autoplay,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsBar(
    VideoPlayerController controller,
    VideoPlayerValue value,
  ) {
    final durationMs = value.duration.inMilliseconds.toDouble();
    final safeMax = durationMs > 0 ? durationMs : 1.0;
    final currentMs =
        (_scrubPositionMs ?? value.position.inMilliseconds.toDouble()).clamp(
          0.0,
          safeMax,
        );
    final bufferedMs = value.buffered.isNotEmpty
        ? value.buffered.last.end.inMilliseconds.toDouble().clamp(0.0, safeMax)
        : 0.0;

    final displayPosition = Duration(milliseconds: currentMs.round());
    final volumeIcon = switch (_volume) {
      0.0 => Icons.volume_off_rounded,
      < 0.5 => Icons.volume_down_rounded,
      _ => Icons.volume_up_rounded,
    };

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: Colors.blueAccent,
              secondaryActiveTrackColor: Colors.white38,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
            ),
            child: Slider(
              min: 0,
              max: safeMax,
              value: currentMs,
              secondaryTrackValue: bufferedMs,
              onChangeStart: (pos) {
                _hideControlsTimer?.cancel();
                setState(() => _scrubPositionMs = pos);
              },
              onChanged: durationMs > 0
                  ? (pos) => setState(() => _scrubPositionMs = pos)
                  : null,
              onChangeEnd: (pos) async {
                setState(() => _scrubPositionMs = null);
                await controller.seekTo(Duration(milliseconds: pos.round()));
                _scheduleHideControls();
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                tooltip: value.isPlaying ? 'Pause' : 'Play',
                onPressed: _togglePlayPause,
              ),
              GapSizes.xsGap,
              Text(
                '${_formatDuration(displayPosition)} / ${_formatDuration(value.duration)}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(volumeIcon, color: Colors.white, size: 20),
                tooltip: _volume == 0 ? 'Unmute' : 'Mute',
                onPressed: _toggleMute,
              ),
              SizedBox(
                width: 84,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.5,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(value: _volume, onChanged: _setVolume),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  widget.isExpanded
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  color: Colors.white,
                ),
                tooltip: widget.isExpanded ? 'Restore' : 'Expand',
                onPressed: _handleExpand,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerWidget = _buildVideoSurface();

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
    final pos = _playerKey.currentState?.currentPosition;
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
