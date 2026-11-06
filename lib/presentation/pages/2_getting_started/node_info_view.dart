part of 'project_file_structure.dart';

/// What the picked file does.
class _NodeInfoView extends StatelessWidget {
  const _NodeInfoView({required this.node});

  final FileNode node;

  @override
  Widget build(BuildContext context) {
    return AppCard.lightbulb(
      title: node.name,
      description: node.description ?? '',
    );
  }
}
