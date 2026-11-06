import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/file_widget_tree.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'getting_started_module.dart';

part 'node_info_view.dart';
part 'pick_a_file_hint.dart';

class ProjectFileStructure extends SignalStatefulWidget {
  const ProjectFileStructure({super.key});

  @override
  State<ProjectFileStructure> createState() => _ProjectFileStructureState();
}

class _ProjectFileStructureState extends State<ProjectFileStructure> {
  final _currentNode = Signal<FileNode?>(null);

  @override
  void dispose() {
    _currentNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedNode = _currentNode.value;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 4,
      title: 'Project File Structure',
      subtitle: 'Tap around. This is the game you are about to build.',
      leftPaneWidgets: [
        FileTreeWidget(onFileTapped: (node) => _currentNode.value = node),
      ],
      rightPaneWidets: [
        if (selectedNode != null)
          _NodeInfoView(node: selectedNode)
        else
          const _PickAFileHint(),
      ],
    );
  }
}
