import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const CourseVideoPlayer({super.key, required this.videoUrl});

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
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * (9.0 / 16.0),
        child: Video(
          controller: _controller,
          controls:
              AdaptiveVideoControls, // Built-in play, pause, seek controls
        ),
      ),
    );
  }
}
