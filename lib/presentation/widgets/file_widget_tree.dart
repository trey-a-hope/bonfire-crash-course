import 'package:flutter/material.dart';

/// Pre-configured file tree widget displaying the course project structure.
const FileTreeWidget = _FileTreeWidget(node: _projectTree);

/// Data model representing a file or directory node in the file tree.
class _FileNode {
  final String name;
  final bool isDirectory;
  final List<_FileNode> children;

  const _FileNode({
    required this.name,
    this.isDirectory = false,
    this.children = const [],
  });
}

/// Project directory and file hierarchy layout.
const _projectTree = _FileNode(
  name: 'bonfire_crash_course_template',
  isDirectory: true,
  children: [
    _FileNode(
      name: 'assets',
      isDirectory: true,
      children: [
        _FileNode(
          name: 'images',
          isDirectory: true,
          children: [
            _FileNode(
              name: 'background',
              isDirectory: true,
              children: [
                _FileNode(name: 'clouds.png'),
                _FileNode(name: 'hills.png'),
                _FileNode(name: 'mountains.png'),
                _FileNode(name: 'sky.png'),
              ],
            ),
            _FileNode(name: 'map.json'),
            _FileNode(name: 'spritesheet.png'),
          ],
        ),
      ],
    ),
    _FileNode(
      name: 'lib',
      isDirectory: true,
      children: [
        _FileNode(name: 'main.dart'),
        _FileNode(
          name: 'presentation',
          isDirectory: true,
          children: [
            _FileNode(
              name: 'backgrounds',
              isDirectory: true,
              children: [_FileNode(name: 'parallax_background.dart')],
            ),
            _FileNode(
              name: 'screens',
              isDirectory: true,
              children: [_FileNode(name: 'game_screen.dart')],
            ),
          ],
        ),
      ],
    ),
    _FileNode(
      name: 'web',
      isDirectory: true,
      children: [_FileNode(name: 'index.html')],
    ),
    _FileNode(
      name: '.devcontainer',
      isDirectory: true,
      children: [_FileNode(name: 'devcontainer.json')],
    ),
    _FileNode(
      name: '.vscode',
      isDirectory: true,
      children: [
        _FileNode(name: 'launch.json'),
        _FileNode(name: 'tasks.json'),
      ],
    ),
    _FileNode(name: 'devtools_options.yaml'),
    _FileNode(name: 'pubspec.yaml'),
    _FileNode(name: 'pubspec.lock'),
  ],
);

/// Recursive widget for rendering directory nodes and file items.
class _FileTreeWidget extends StatelessWidget {
  final _FileNode node;
  final double indent;

  const _FileTreeWidget({required this.node, this.indent = 0});

  /// Maps file extensions to corresponding Flutter icons.
  IconData _getFileIcon(String filename) {
    if (filename.endsWith('.dart')) return Icons.code;
    if (filename.endsWith('.png')) return Icons.image;
    if (filename.endsWith('.json')) return Icons.data_object;
    if (filename.endsWith('.yaml') || filename.endsWith('.lock')) {
      return Icons.settings;
    }
    if (filename.endsWith('.html')) return Icons.language;
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    // Render file item with indent and file type icon
    if (!node.isDirectory) {
      return Padding(
        padding: EdgeInsets.only(left: indent + 16.0, top: 2.0, bottom: 2.0),
        child: Row(
          children: [
            Icon(_getFileIcon(node.name), size: 16, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(
              node.name,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ],
        ),
      );
    }

    // Render expandable directory tile with recursive children
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        dense: true,
        visualDensity: VisualDensity.compact,
        tilePadding: EdgeInsets.only(left: indent),
        leading: const Icon(Icons.folder, size: 18, color: Colors.amber),
        title: Text(
          node.name,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        children: node.children
            .map((child) => _FileTreeWidget(node: child, indent: indent + 14.0))
            .toList(),
      ),
    );
  }
}
