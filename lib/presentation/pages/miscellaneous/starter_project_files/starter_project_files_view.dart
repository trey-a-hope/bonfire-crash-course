import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/file_widget_tree.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

part 'node_info_view.dart';
part 'pick_a_file_hint.dart';

/// The Starter Project Files tab of the Course Info page: a tour of the
/// starter project's files.
///
/// The tree shows the starter template as shipped, not the learner's live
/// repo.
class StarterProjectFilesView extends SignalStatefulWidget {
  /// Sets expectations: the tree is the starter project, not a live view.
  static const note =
      'This shows the starter project. Files you add yourself won\'t appear here.';

  /// Creates the [StarterProjectFilesView].
  const StarterProjectFilesView({super.key});

  @override
  State<StarterProjectFilesView> createState() =>
      _StarterProjectFilesViewState();
}

class _StarterProjectFilesViewState extends State<StarterProjectFilesView> {
  final _currentNode = Signal<FileNode?>(null);

  @override
  void dispose() {
    _currentNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedNode = _currentNode.value;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tap around to see what each file in the course project does.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          GapSizes.xsGap,
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Colors.white54,
              ),
              GapSizes.xsGap,
              Flexible(
                child: Text(
                  StarterProjectFilesView.note,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white54),
                ),
              ),
            ],
          ),
          GapSizes.largeGap,

          // The animation stays on the left, with the picked file's
          // explanation underneath it. The tree is on the right.
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AnimatedHeroCard(
                          scene: GettingStartedScene.fileStructure,
                        ),
                        GapSizes.mediumGap,
                        if (selectedNode != null)
                          _NodeInfoView(node: selectedNode)
                        else
                          const _PickAFileHint(),
                      ],
                    ),
                  ),
                ),
                GapSizes.largeGap,
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: FileTreeWidget(
                      onFileTapped: (node) => _currentNode.value = node,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
