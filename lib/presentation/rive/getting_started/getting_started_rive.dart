import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:signals/signals_flutter.dart';

part 'getting_started_scene.dart';
part 'getting_started_rive_fallback.dart';

/// Plays one of the Getting Started hero animations from `assets/rive/`.
///
/// Every file has the same shape (built by `tool/rive/build_getting_started.py`):
/// one artboard, the `State Machine 1` state machine that loops on load, and a
/// `GettingStarted` view model with one boolean, `reduceMotion`. When the
/// platform asks for reduced motion, `reduceMotion` is set and the animation
/// holds a still pose.
///
/// If the file can't be loaded, a calm icon for the [scene] is shown instead.
class GettingStartedRive extends SignalStatefulWidget {
  /// Which animation to play.
  final GettingStartedScene scene;

  /// How the artboard is scaled to fit within its bounds.
  final rive.Fit fit;

  const GettingStartedRive({
    super.key,
    required this.scene,
    this.fit = rive.Fit.contain,
  });

  /// Name of the state machine in every Getting Started file.
  static const stateMachineName = 'State Machine 1';

  /// Name of the view model boolean that switches to the still pose.
  static const reduceMotionProperty = 'reduceMotion';

  /// Loads a bundled Rive file. Tests replace it, since the native Rive
  /// runtime isn't available under `flutter test`.
  @visibleForTesting
  static Future<rive.File?> Function(String assetPath) loadFile = _loadAsset;

  static Future<rive.File?> _loadAsset(String assetPath) =>
      rive.File.asset(assetPath, riveFactory: rive.Factory.rive);

  @override
  State<GettingStartedRive> createState() => _GettingStartedRiveState();
}

class _GettingStartedRiveState extends State<GettingStartedRive> {
  /// The playing animation, once the file has loaded.
  final _controller = Signal<rive.RiveWidgetController?>(null);

  /// True when the file couldn't be loaded.
  final _failed = Signal<bool>(false);

  rive.File? _file;
  rive.ViewModelInstance? _viewModel;
  rive.ViewModelInstanceBoolean? _reduceMotion;

  /// Whether the platform asks for reduced motion.
  bool _reduceMotionWanted = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotionWanted = MediaQuery.disableAnimationsOf(context);
    _reduceMotion?.value = _reduceMotionWanted;
  }

  Future<void> _load() async {
    final assetPath = widget.scene.assetPath;
    try {
      final file = await GettingStartedRive.loadFile(assetPath);
      if (file == null) {
        if (mounted) _failed.value = true;
        return;
      }
      if (!mounted) {
        file.dispose();
        return;
      }

      final controller = rive.RiveWidgetController(
        file,
        artboardSelector: rive.ArtboardSelector.byName(
          widget.scene.artboardName,
        ),
        stateMachineSelector: rive.StateMachineSelector.byName(
          GettingStartedRive.stateMachineName,
        ),
      );
      final viewModel = controller.dataBind(rive.DataBind.auto());
      final reduceMotion = viewModel.boolean(
        GettingStartedRive.reduceMotionProperty,
      );
      reduceMotion?.value = _reduceMotionWanted;

      _file = file;
      _viewModel = viewModel;
      _reduceMotion = reduceMotion;
      _controller.value = controller;
    } catch (error, stackTrace) {
      debugPrint('Failed to load $assetPath: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) _failed.value = true;
    }
  }

  @override
  void dispose() {
    // Dispose in reverse order of creation, as the Rive docs recommend.
    _reduceMotion?.dispose();
    _viewModel?.dispose();
    _controller.value?.dispose();
    _file?.dispose();
    _controller.dispose();
    _failed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller.value;

    if (_failed.value) {
      return _GettingStartedRiveFallback(scene: widget.scene);
    }
    if (controller == null) {
      return const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return rive.RiveWidget(controller: controller, fit: widget.fit);
  }
}
