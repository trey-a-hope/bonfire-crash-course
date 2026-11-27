part of 'onboarding.dart';

/// A terminal command in a box with a Copy button. The button reads
/// "Copied!" for a moment after it's pressed.
class CommandBox extends SignalStatefulWidget {
  /// The command to show and copy.
  final String command;

  const CommandBox({super.key, required this.command});

  /// How long the button reads "Copied!".
  static const copiedFor = Duration(milliseconds: 1500);

  @override
  State<CommandBox> createState() => _CommandBoxState();
}

class _CommandBoxState extends State<CommandBox> {
  /// True right after the command was copied.
  final _copied = Signal<bool>(false);

  Timer? _reset;

  Future<void> _copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.command));
    } on PlatformException catch (error) {
      // The command stays selectable, so it can still be copied by hand.
      debugPrint('Could not copy the command: $error');
      return;
    }
    if (!mounted) return;
    _copied.value = true;
    _reset?.cancel();
    _reset = Timer(CommandBox.copiedFor, () {
      if (mounted) _copied.value = false;
    });
  }

  @override
  void dispose() {
    _reset?.cancel();
    _copied.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copied = _copied.value;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Wraps on a narrow pane, so the whole command stays readable.
          Expanded(
            child: SelectableText(
              widget.command,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: Colors.greenAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GapSizes.smallGap,
          TextButton.icon(
            onPressed: _copy,
            icon: Icon(
              copied ? Icons.check_rounded : Icons.copy_rounded,
              size: 14,
            ),
            label: Text(
              copied ? 'Copied!' : 'Copy',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
