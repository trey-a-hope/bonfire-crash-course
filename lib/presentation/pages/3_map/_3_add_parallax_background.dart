import '../../../core/modules/map_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_GAME_SCREEN = 'lib/presentation/screens/game_screen.dart';

class AddParallaxBackground extends StatelessWidget {
  const AddParallaxBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      module: MAP_MODULE,
      unitStep: 3,
      title: 'Add Parallax Background',
      subtitle: 'Apply the parallax background to your game world.',
      outcome: 'The parallax background is now applied to your game world.',
      objective:
          'The game world should now display a parallax background with a sky that moves independently of the player.',
      concepts: [
        Concept(
          title: 'MoveCameraUsingGesture',
          short: 'Drag to move the camera.',
          subtitle:
              'A Bonfire mixin for game components that moves the camera when you drag with a mouse or finger, so you can look around the map without moving the player.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
// The background you just built and the template's camera drag component.
+ import 'package:bonfire_crash_course_playground/presentation/backgrounds/parallax_background.dart';
+ import 'package:bonfire_crash_course_playground/presentation/components/camera_drag.dart';
''',
        ),
        CodeStep(
          description:
              'Create an instance of the ParallaxBackground class and an instance of the CameraDrag class.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
class _GameScreenState extends State<GameScreen> {
+   final _background = ParallaxBackground();
+   final _cameraDrag = CameraDrag();
}
''',
        ),

        CodeStep(
          description:
              'In the build method, pass the background to BonfireWidget\'s background parameter and add a CameraDrag instance to its components list.',
          fileName: _DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
Widget build(BuildContext context) {
  return BonfireWidget(
+     background: _background,
+     components: [_cameraDrag],
  );
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to create a ParallaxBackground class in parallax_background.dart with a sky layer that scrolls on its own and a hills layer that follows the camera, then pass it to BonfireWidget\'s background.',
      proTip:
          'Layers draw in the order you add them, so add the far-away sky first and the closer hills after it, or the hills will be hidden behind the sky.',
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
    );
  }
}
