import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'getting_started_module.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/file_widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ProjectFileStructure extends SignalStatefulWidget {
  const ProjectFileStructure({super.key});

  @override
  State<ProjectFileStructure> createState() => _ProjectFileStructureState();
}

class _ProjectFileStructureState extends State<ProjectFileStructure> {
  final _currentNode = Signal<FileNode?>(null);

  @override
  Widget build(BuildContext context) {
    final selectedNode = _currentNode.value;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      leftPaneWidgets: [
        AppCard.objective(
          title: "See what files you're working with",
          description:
              'This is the basic structure of a Bonfire game. It is not a strict requirement to follow this structure, but it is recommended.',
        ),
        GapSizes.mediumGap,
        FileTreeWidget(onFileTapped: (node) => _currentNode.value = node),
      ],
      rightPaneWidets: [
        if (selectedNode != null)
          _NodeInfoView(node: selectedNode)
        else
          const Placeholder(),
      ],
      unitStep: 4,
      title: 'Project File Structure',
    );
  }
}

class _NodeInfoView extends StatelessWidget {
  const _NodeInfoView({required this.node});

  final FileNode node;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard.lightbulb(
          title: node.name,
          description: node.description ?? '',
        ),
      ],
    );
  }
}
