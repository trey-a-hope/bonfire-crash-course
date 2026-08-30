import 'package:flutter/material.dart';
import 'package:flutter_dartpad/flutter_dartpad.dart';

class DartPadExerciseScreen extends StatelessWidget {
  // Replace with your GitHub Gist ID containing main.dart / test.dart
  final String gistId;
  const DartPadExerciseScreen({required this.gistId, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adding a player',
                        style: textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Divider(),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since 1966, when designers at Letraset and James Mosley, the librarian at St Bride Printing Library in London, took a 1914 Cicero translation and scrambled it to make dummy text for Letraset\'s Body Type sheets. It has survived not only many decades, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised thanks to these sheets and more recently with desktop publishing software like Aldus PageMaker and Microsoft Word including versions of Lorem Ipsum.',
                        style: textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 16),
            child: Dartpad(
              key: const Key('exercise_dartpad'),
              embeddingChoice: EmbeddingChoice.flutter,
              gistId: gistId,
              darkMode: true,
              split: 60, // Split ratio between editor and output (60% editor)
              runImmediately: false, // Wait for user to finish and hit Run
              onProgress: (val) => debugPrint(val.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
