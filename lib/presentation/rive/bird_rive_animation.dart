import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:rive/rive.dart' as rive;

/// Values of the `activity` number property in `bird_behavior.riv`.
///
/// The number on each value is what the "Activity" layer of the
/// "Bird Behavior" state machine listens for.
enum BirdActivity {
  /// Sitting still on its perch (the default).
  perched(0),

  /// Hopping in place.
  hopping(1),

  /// Pecking at the ground.
  pecking(2),

  /// Asleep on the perch.
  sleeping(3),

  /// Takes off from the perch and starts flapping.
  takeoff(4),

  /// Keeps flapping while in the air.
  flapping(5),

  /// Glides while in the air.
  gliding(6),

  /// Dives while in the air.
  diving(7),

  /// Lands from the air back onto the perch.
  landing(8);

  const BirdActivity(this.value);

  /// The number the state machine expects for this activity.
  final double value;
}

/// Values of the `expression` number property in `bird_behavior.riv`.
enum BirdExpression {
  neutral(0),
  blink(1),
  lookLeft(2),
  lookRight(3),
  headTilt(4);

  const BirdExpression(this.value);

  /// The number the state machine expects for this expression.
  final double value;
}

/// Displays the animated bird from `assets/rive/bird_behavior.riv`.
///
/// The file has a "Bird" artboard driven by the "Bird Behavior" state
/// machine, which is controlled through its view model:
///
/// * `activity` (number) - see [BirdActivity].
/// * `expression` (number) - see [BirdExpression].
/// * `startle` (trigger) - the bird squawks and flies off.
///
/// When [startleOnTap] is true, tapping the bird fires `startle`, then the
/// bird lands again and goes back to [activity].
class BirdRiveAnimation extends StatefulWidget {
  /// Path of the bundled Rive file.
  static const String assetPath = 'assets/rive/bird_behavior.riv';

  /// Name of the artboard inside the Rive file.
  static const String artboardName = 'Bird';

  /// Name of the state machine that drives the artboard.
  static const String stateMachineName = 'Bird Behavior';

  /// The height constraint applied to the animation canvas.
  final double? height;

  /// The width constraint applied to the animation canvas.
  final double? width;

  /// How the artboard is scaled to fit within its bounds.
  final rive.Fit fit;

  /// What the bird is doing.
  final BirdActivity activity;

  /// The bird's facial expression.
  final BirdExpression expression;

  /// Whether tapping the bird startles it.
  final bool startleOnTap;

  const BirdRiveAnimation({
    super.key,
    this.height = 160,
    this.width,
    this.fit = rive.Fit.contain,
    this.activity = BirdActivity.perched,
    this.expression = BirdExpression.neutral,
    this.startleOnTap = true,
  });

  @override
  State<BirdRiveAnimation> createState() => _BirdRiveAnimationState();
}

class _BirdRiveAnimationState extends State<BirdRiveAnimation> {
  /// How long the bird stays in the air after being startled.
  static const _flightDuration = Duration(milliseconds: 2500);

  /// How long the landing animation takes before resuming [activity].
  static const _landingDuration = Duration(milliseconds: 1500);

  rive.File? _file;
  rive.RiveWidgetController? _controller;
  rive.ViewModelInstance? _viewModel;
  rive.ViewModelInstanceNumber? _activity;
  rive.ViewModelInstanceNumber? _expression;
  rive.ViewModelInstanceTrigger? _startle;
  Timer? _startleTimer;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final file = await rive.File.asset(
        BirdRiveAnimation.assetPath,
        riveFactory: rive.Factory.rive,
      );
      if (file == null) {
        if (mounted) setState(() => _failed = true);
        return;
      }
      if (!mounted) {
        file.dispose();
        return;
      }

      final controller = rive.RiveWidgetController(
        file,
        artboardSelector: rive.ArtboardSelector.byName(
          BirdRiveAnimation.artboardName,
        ),
        stateMachineSelector: rive.StateMachineSelector.byName(
          BirdRiveAnimation.stateMachineName,
        ),
      );
      final viewModel = controller.dataBind(rive.DataBind.auto());

      setState(() {
        _file = file;
        _controller = controller;
        _viewModel = viewModel;
        _activity = viewModel.number('activity');
        _expression = viewModel.number('expression');
        _startle = viewModel.trigger('startle');
      });
      _applyProperties();
    } catch (error, stackTrace) {
      debugPrint('Failed to load ${BirdRiveAnimation.assetPath}: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didUpdateWidget(covariant BirdRiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity != widget.activity ||
        oldWidget.expression != widget.expression) {
      _applyProperties();
    }
  }

  /// Pushes [BirdRiveAnimation.activity] and [BirdRiveAnimation.expression]
  /// into the view model.
  void _applyProperties() {
    _activity?.value = widget.activity.value;
    _expression?.value = widget.expression.value;
  }

  /// Startles the bird, then lands it and resumes its normal activity.
  void _onTap() {
    if (_startleTimer?.isActive ?? false) return;
    _startle?.trigger();
    _startleTimer = Timer(_flightDuration, () {
      _activity?.value = BirdActivity.landing.value;
      _startleTimer = Timer(_landingDuration, _applyProperties);
    });
  }

  @override
  void dispose() {
    _startleTimer?.cancel();
    // Dispose in reverse order of creation, as the Rive docs recommend.
    _startle?.dispose();
    _expression?.dispose();
    _activity?.dispose();
    _viewModel?.dispose();
    _controller?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    final Widget child;
    if (_failed) {
      child = const SizedBox.shrink();
    } else if (controller == null) {
      child = const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else {
      final riveView = rive.RiveWidget(controller: controller, fit: widget.fit);
      child = widget.startleOnTap
          ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTap,
                child: riveView,
              ),
            )
          : riveView;
    }

    return SizedBox(height: widget.height, width: widget.width, child: child);
  }
}
