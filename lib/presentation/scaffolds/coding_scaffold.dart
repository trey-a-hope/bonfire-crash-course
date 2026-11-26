import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/widgets/lesson/lesson.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart'
    show OneLineTip;
import 'package:bonfire_crash_course/presentation/widgets/step_badge_header.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

/// A standardized split-pane layout scaffold for interactive coding lessons.
///
/// The code leads. On the left (flex 3), the key concepts are chips above the
/// code steps: tapping one shows what it does in one line and lights up the
/// code lines it's about, with the full explanation behind "Learn more". On
/// the right (flex 2), the lesson's result sits in one line (the objective
/// and what you're about to type are behind "Learn more"), then a one-line
/// pro-tip and a button that opens the video walkthrough.
class CodingScaffold extends SignalStatefulWidget {
  /// The module metadata (module name, total steps, accent color).
  final Module module;

  /// Current step index within this module.
  final int unitStep;

  /// Optional extra badge label displayed beside the step counter.
  final String? unitExtra;

  /// Main lesson title.
  final String title;

  /// Optional subtitle or high-level overview.
  final String? subtitle;

  /// The full objective of the lesson, shown behind "Learn more".
  final String objective;

  /// What the student has when the lesson is done, in one line.
  final String outcome;

  /// The lesson's key concepts, shown as chips above the code.
  final List<Concept> concepts;

  /// Step-by-step code implementation instructions.
  final List<CodeStep> codeSteps;

  /// One or two sentences telling the student what they're about to type,
  /// shown with the objective behind "Learn more".
  final String timeToCodeStatement;

  /// Quick advice for this lesson, shown as a one-line tip. Hidden when
  /// this is null.
  final String? proTip;

  /// URL for the lesson video walkthrough, opened on demand.
  final String videoUrl;

  /// Optional title override for the video player header.
  final String? videoTitle;

  const CodingScaffold({
    super.key,
    required this.module,
    required this.unitStep,
    this.unitExtra,
    required this.title,
    this.subtitle,
    required this.objective,
    required this.outcome,
    required this.concepts,
    required this.codeSteps,
    required this.timeToCodeStatement,
    this.proTip,
    required this.videoUrl,
    this.videoTitle,
  });

  @override
  State<CodingScaffold> createState() => _CodingScaffoldState();
}

class _CodingScaffoldState extends State<CodingScaffold> {
  /// Index of the concept being explained; the first one to begin with.
  late final _selected = Signal<int?>(widget.concepts.isEmpty ? null : 0);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = _selected.value;
    final concepts = widget.concepts;
    final picked = selected == null || selected >= concepts.length
        ? null
        : concepts[selected];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module progression badge & step tracker
        StepBadgeHeader(
          title: widget.module.moduleName.toUpperCase(),
          currentStep: widget.unitStep,
          totalSteps: widget.module.totalSteps,
          color: widget.module.accentColor,
          extra: widget.unitExtra,
        ),
        GapSizes.smallGap,

        // Page title
        Text(
          widget.title,
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Optional subtitle
        if (widget.subtitle != null) ...[
          GapSizes.xsGap,
          Text(
            widget.subtitle!,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
        GapSizes.largeGap,

        // Main Split Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: concept chips & code steps (Flex 3)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (concepts.isNotEmpty) ...[
                        ConceptChips(
                          concepts: concepts,
                          selected: picked == null ? null : selected,
                          onSelected: (index) => _selected.value = index,
                        ),
                        GapSizes.mediumGap,
                      ],
                      if (widget.codeSteps.isNotEmpty)
                        StepsWidget.code(codeSteps: widget.codeSteps),
                      LessonOutcomeCard(
                        outcome: widget.outcome,
                        objective: widget.objective,
                        timeToCodeStatement: widget.timeToCodeStatement,
                      ),
                      if (widget.proTip != null) ...[
                        GapSizes.mediumGap,
                        OneLineTip(text: widget.proTip!),
                      ],
                      GapSizes.mediumGap,
                      WalkthroughButton(
                        videoUrl: widget.videoUrl,
                        title: widget.videoTitle ?? '${widget.title} Tutorial',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
