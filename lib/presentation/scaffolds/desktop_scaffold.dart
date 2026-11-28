import 'package:bonfire_crash_course/core/platform_resolver.dart';
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

  /// Whether the left sidebar is shown. Toggled by the sidebar's close button
  /// and the reopen button shown over the content while it's closed.
  bool _isSidebarOpen = true;

  /// Width of the sidebar plus its 1px divider.
  static const double _sidebarWidth = 281.0;

  void _setSidebarOpen(bool open) => setState(() => _isSidebarOpen = open);

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
            // Same as the sidebar: on phones/tablets, push the content below
            // the status bar and any notch or camera cutout.
            padding: EdgeInsets.fromLTRB(
              32.0,
              PlatformResolver.isMobile
                  ? MediaQuery.paddingOf(context).top + 32.0
                  : 32.0,
              32.0,
              32.0,
            ),
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
            // Animate the width to 0 when closed. The OverflowBox keeps the
            // sidebar at full width so its contents slide off instead of
            // reflowing.
            ClipRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: _isSidebarOpen ? _sidebarWidth : 0.0,
                child: OverflowBox(
                  alignment: Alignment.centerRight,
                  minWidth: _sidebarWidth,
                  maxWidth: _sidebarWidth,
                  child: Row(
                    children: [
                      Sidebar(
                        currentIndex: widget.navigationShell.currentIndex,
                        progressPercentage: progressPercentage,
                        progressColor: progressColor,
                        progressFraction: progressFraction,
                        showProgress:
                            ProgressNavigationController.isProgressVisible(
                              widget.navigationShell,
                            ),
                        goBranch: (val, {bool initialLocation = false}) =>
                            widget.navigationShell.goBranch(
                              val,
                              initialLocation:
                                  val == widget.navigationShell.currentIndex,
                            ),
                        onClose: () => _setSidebarOpen(false),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFF26262B),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: content),
                  // Reopen button, tucked into the content's 32px padding.
                  Positioned(
                    top: PlatformResolver.isMobile
                        ? MediaQuery.paddingOf(context).top
                        : 0.0,
                    left: 0.0,
                    child: AnimatedOpacity(
                      opacity: _isSidebarOpen ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: IgnorePointer(
                        ignoring: _isSidebarOpen,
                        child: IconButton(
                          tooltip: 'Open sidebar',
                          visualDensity: VisualDensity.compact,
                          iconSize: 20.0,
                          color: Colors.white54,
                          icon: const Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                          ),
                          onPressed: () => _setSidebarOpen(true),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
