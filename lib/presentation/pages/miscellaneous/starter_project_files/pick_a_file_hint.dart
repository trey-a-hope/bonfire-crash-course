part of 'starter_project_files_page.dart';

/// A nudge under the animation, shown until a file is picked.
class _PickAFileHint extends StatelessWidget {
  const _PickAFileHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tap a file to see what it does',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
