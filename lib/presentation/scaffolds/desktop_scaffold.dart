import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/sidebar.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_navigator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

/// The primary desktop window shell for the application.
///
/// Implements a responsive split-view desktop layout:
/// - A left sidebar with branding, navigation tree, and settings.
/// - A main content window hosting the active lesson branch and navigation controls.
///
/// Built with pure Flutter Material widgets to provide a consistent desktop
/// experience across all host operating systems.
class DesktopScaffold extends SignalStatefulWidget {
  final StatefulNavigationShell navigationShell;

  /// Creates the [AdaptiveWindow] shell widget.
  const DesktopScaffold({super.key, required this.navigationShell});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

/// State implementation managing desktop navigation and layout.
class _DesktopScaffoldState extends State<DesktopScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    final curved = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOut,
    );
    _fadeAnimation = curved;
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.025),
      end: Offset.zero,
    ).animate(curved);
    _transitionController.forward();
    _lastIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(DesktopScaffold old) {
    super.didUpdateWidget(old);
    if (widget.navigationShell.currentIndex != _lastIndex) {
      _lastIndex = widget.navigationShell.currentIndex;
      _transitionController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercentage = ProgressNavigationController.progress(
      widget.navigationShell,
    );
    final progressFraction = (progressPercentage / 100.0).clamp(0.0, 1.0);
    final isComplete = progressPercentage.toInt() >= 100;
    final progressColor = isComplete
        ? const Color(0xFFFFD700)
        : Colors.blueAccent;

    // Right Content Window
    final content = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: widget.navigationShell,
              ),
            ),
          ),
        ),
        // Hide prev/next nav on introduction page
        if (widget.navigationShell.currentIndex > 0) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
            child: PageNavigator(navigationShell: widget.navigationShell),
          ),
        ],
      ],
    );

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
        body: Row(
          children: [
            Sidebar(
              currentIndex: widget.navigationShell.currentIndex,
              progressPercentage: progressPercentage,
              progressColor: progressColor,
              progressFraction: progressFraction,
              showProgress: ProgressNavigationController.isProgressVisible(
                widget.navigationShell,
              ),
              goBranch: (val, {bool initialLocation = false}) =>
                  widget.navigationShell.goBranch(
                    val,
                    initialLocation: val == widget.navigationShell.currentIndex,
                  ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFF26262B),
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
