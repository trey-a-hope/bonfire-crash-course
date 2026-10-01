import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/modules/_modules.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/file_widget_tree.dart';
import 'package:bonfire_crash_course/presentation/widgets/info_card.dart';
import 'package:flutter/material.dart';

class ProjectFileStructure extends StatelessWidget {
  const ProjectFileStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return const InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      leftPaneWidgets: [
        InfoCard(
          title: 'See what files you\'re working with',
          description:
              'This is the basic structure of a Bonfire game. It is not a strict requirement to follow this structure, but it is recommended.',
        ),
        GapSizes.mediumGap,
        FileTreeWidget,
      ],
      rightPaneWidets: [Placeholder()],
      unitStep: 4,
      title: 'Project File Structure',
    );
  }
}
