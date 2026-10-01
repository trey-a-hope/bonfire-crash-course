import 'package:flutter/material.dart';

/// Pre-configured file tree widget displaying the course project structure.

class FileTreeWidget extends StatelessWidget {
  const FileTreeWidget({super.key, required this.onFileTapped});

  final Function(FileNode node) onFileTapped;

  @override
  Widget build(BuildContext context) {
    return _FileTreeWidget(node: _projectTree, onFileTapped: onFileTapped);
  }
}

/// Data model representing a file or directory node in the file tree.
class FileNode {
  final String name;
  final bool isDirectory;
  final List<FileNode> children;
  final String? description;

  const FileNode({
    required this.name,
    this.isDirectory = false,
    this.children = const [],
    this.description,
  });
}

/// Project directory and file hierarchy layout.
const _projectTree = FileNode(
  name: 'bonfire_crash_course_template',
  isDirectory: true,
  children: [
    FileNode(
      name: 'assets',
      isDirectory: true,
      children: [
        FileNode(
          name: 'images',
          isDirectory: true,
          children: [
            FileNode(
              name: 'background',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'clouds.png',
                  description:
                      'Clouds for the background. They are not animated.',
                ),
                FileNode(
                  name: 'hills.png',
                  description:
                      'Hills for the background. They are not animated.',
                ),
                FileNode(
                  name: 'mountains.png',
                  description:
                      'Mountains for the background. They are not animated.',
                ),
                FileNode(
                  name: 'sky.png',
                  description: 'Sky for the background. It is not animated.',
                ),
              ],
            ),
            FileNode(
              name: 'map.json',
              description: 'Game map for the game. It is not animated.',
            ),
            FileNode(
              name: 'spritesheet.png',
              description: 'Spritesheet for the game. It is not animated.',
            ),
          ],
        ),
      ],
    ),
    FileNode(
      name: 'lib',
      isDirectory: true,
      children: [
        FileNode(
          name: 'main.dart',
          description:
              'The entry point of the application. It is where the game is initialized and the game loop is started.',
        ),
        FileNode(
          name: 'presentation',
          isDirectory: true,
          children: [
            FileNode(
              name: 'backgrounds',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'parallax_background.dart',
                  description:
                      'Parallax background for the game. It is not animated.',
                ),
              ],
            ),
            FileNode(
              name: 'screens',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'game_screen.dart',
                  description: 'Game screen for the game. It is not animated.',
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Recursive widget for rendering directory nodes and file items.
class _FileTreeWidget extends StatelessWidget {
  final Function(FileNode node) onFileTapped;
  final FileNode node;
  final double indent;

  const _FileTreeWidget({
    required this.node,
    this.indent = 0,
    required this.onFileTapped,
  });

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
        child: GestureDetector(
          onTap: () => onFileTapped(node),
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
            .map(
              (child) => _FileTreeWidget(
                node: child,
                indent: indent + 14.0,
                onFileTapped: onFileTapped,
              ),
            )
            .toList(),
      ),
    );
  }
}
