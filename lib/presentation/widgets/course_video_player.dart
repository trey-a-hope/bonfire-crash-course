import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onToggleExpand;
  final bool isExpanded;

  const CourseVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onToggleExpand,
    this.isExpanded = false,
  });

  /// Opens the [CourseVideoPlayer] inside a modal dialog.
  static Future<void> showModal(
    BuildContext context, {
    required String videoUrl,
    String title = 'Course Video',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (BuildContext context) {
        return CourseVideoModalDialog(
          videoUrl: videoUrl,
          title: title,
        );
      },
    );
  }

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  final _player = Player();
  late final _controller = VideoController(_player);

  @override
  void initState() {
    super.initState();
    _player.setPlaylistMode(PlaylistMode.single);
    _player.open(Media(widget.videoUrl));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomControls = [
      const MaterialPlayOrPauseButton(),
      const MaterialPositionIndicator(),
      const Spacer(),
      const MaterialDesktopVolumeButton(),
      if (widget.onToggleExpand != null)
        MaterialCustomButton(
          onPressed: widget.onToggleExpand!,
          icon: Icon(
            widget.isExpanded
                ? Icons.fullscreen_exit_rounded
                : Icons.fullscreen_rounded,
            color: Colors.white,
          ),
        ),
    ];

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(
          bottomButtonBar: bottomControls,
        ),
        fullscreen: MaterialVideoControlsThemeData(
          bottomButtonBar: bottomControls,
        ),
        child: Video(
          controller: _controller,
          controls: MaterialVideoControls,
        ),
      ),
    );
  }
}

class CourseVideoModalDialog extends StatefulWidget {
  final String videoUrl;
  final String title;

  const CourseVideoModalDialog({
    super.key,
    required this.videoUrl,
    this.title = 'Course Video',
  });

  @override
  State<CourseVideoModalDialog> createState() => _CourseVideoModalDialogState();
}

class _CourseVideoModalDialogState extends State<CourseVideoModalDialog> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final maxWidth = _isExpanded ? screenSize.width * 0.95 : 900.0;
    final maxHeight =
        _isExpanded ? screenSize.height * 0.95 : screenSize.height * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
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
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
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
                  videoUrl: widget.videoUrl,
                  onToggleExpand: _toggleExpand,
                  isExpanded: _isExpanded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


