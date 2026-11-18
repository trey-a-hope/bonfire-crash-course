import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/file_widget_tree.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

part 'node_info_view.dart';
part 'pick_a_file_hint.dart';

/// A reference tour of the starter project, opened from the sidebar footer.
///
/// It sits outside the course flow, like Settings, so it never counts toward
/// progress. The tree shows the starter template as shipped, not the
/// learner's live repo.
class StarterProjectFilesPage extends SignalStatefulWidget {
  /// The route path for the starter project files page.
  static const path = '/starter-project-files';

  /// Sets expectations: the tree is the starter project, not a live view.
  static const note =
      'This shows the starter project. Files you add yourself won\'t appear here.';

  const StarterProjectFilesPage({super.key});

  @override
  State<StarterProjectFilesPage> createState() =>
      _StarterProjectFilesPageState();
}

class _StarterProjectFilesPageState extends State<StarterProjectFilesPage> {
  final _currentNode = Signal<FileNode?>(null);

  @override
  void dispose() {
    _currentNode.dispose();
    super.dispose();
  }

  /// Returns to the previous page, or to the first lesson if there is none.
  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ProgressNavigationController.navigateablePanes.first.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedNode = _currentNode.value;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: _close,
                  ),
                  GapSizes.smallGap,
                  Text(
                    'Starter Project Files',
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GapSizes.smallGap,
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
                      StarterProjectFilesPage.note,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white54,
                      ),
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
        ),
      ),
    );
  }
}
