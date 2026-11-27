import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/content_outline/content_outline_view.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/starter_project_files/starter_project_files_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

/// The Course Info page, opened from the sidebar footer.
///
/// It holds two reference tabs: the [ContentOutlineView] (a map of every
/// module) and the [StarterProjectFilesView] (a tour of the starter project).
/// Like Settings, it sits outside the course shell (see
/// `lib/core/app_router.dart`), so it has no Previous/Next controls and never
/// changes course progress.
///
/// The tabs live in an [IndexedStack], so switching tabs keeps each tab's
/// state, such as the file picked in Starter Project Files.
class CourseInfoPage extends StatefulWidget {
  /// The route path for the Course Info page.
  static const path = '/course-info';

  /// Creates the [CourseInfoPage].
  const CourseInfoPage({super.key});

  @override
  State<CourseInfoPage> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  )..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Returns to the previous page, or to the first lesson if there is none
  /// (for example when the app opened straight on this route).
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

    // Same dark chrome as SettingsPage, since this page is pushed on the root
    // navigator, outside the desktop scaffold's theme.
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          surface: Color(0xFF141416),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1E),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: back button and page title.
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
                      'Course Info',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GapSizes.mediumGap,
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: const Color(0xFF26262B),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: const [
                    Tab(icon: Icon(Icons.list_alt), text: 'Content Outline'),
                    Tab(
                      icon: Icon(Icons.folder_open_rounded),
                      text: 'Starter Project Files',
                    ),
                  ],
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tabController.index,
                    children: const [
                      ContentOutlineView(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.0),
                        child: StarterProjectFilesView(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
