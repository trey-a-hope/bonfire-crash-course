part of 'onboarding.dart';

/// A short numbered list of steps that slide in one after another.
///
/// Keep it to three steps of a few words each: the animation above does the
/// explaining.
class QuickSteps extends StatelessWidget {
  /// The steps, in order.
  final List<String> steps;

  const QuickSteps({super.key, required this.steps});

  /// How long one step takes to slide in.
  static const stepDuration = Duration(milliseconds: 300);

  /// How long each step waits after the one before it.
  static const stagger = Duration(milliseconds: 120);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: steps
          .mapIndexed(
            (index, step) => Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
              child: QuickStepTile(
                number: index + 1,
                text: step,
                delay: stagger * index,
              ),
            ),
          )
          .toList(),
    );
  }
}
