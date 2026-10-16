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
///
/// Mirrors trey-a-hope/bonfire_crash_course_template; update it when the
/// template's files change (see TEMPLATE_SYNC.md).
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
                  name: 'sky.png',
                  description:
                      'Back layer of the parallax background. Scrolls on its own.',
                ),
                FileNode(
                  name: 'clouds.png',
                  description:
                      'Cloud layer drawn over the sky. Scrolls on its own.',
                ),
                FileNode(
                  name: 'mountains.png',
                  description:
                      'Mountain layer. Moves with the camera for depth.',
                ),
                FileNode(
                  name: 'hills.png',
                  description:
                      'Front hill layer. Moves with the camera faster than the mountains.',
                ),
              ],
            ),
            FileNode(
              name: 'characters',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'shark',
                  isDirectory: true,
                  children: [
                    FileNode(
                      name: 'shark_*.png',
                      description:
                          'Shark sprite sheets: idle, walk, jump, bite and range attacks, hurt, and a water ball projectile. Left and right versions of each.',
                    ),
                  ],
                ),
                FileNode(
                  name: 'wizard',
                  isDirectory: true,
                  children: [
                    FileNode(
                      name: 'wizard_*.png',
                      description:
                          'Wizard sprite sheets: idle, walk, jump, melee and range attacks, hurt, and a magic bolt projectile. Left and right versions of each.',
                    ),
                  ],
                ),
              ],
            ),
            FileNode(
              name: 'maps',
              isDirectory: true,
              children: [
                FileNode(
                  name: '01',
                  isDirectory: true,
                  children: [
                    FileNode(
                      name: '01.json',
                      description:
                          'The Spritefusion project file for level 1. Open it in Spritefusion to edit the level, then export map/ again.',
                    ),
                    FileNode(
                      name: 'map',
                      isDirectory: true,
                      children: [
                        FileNode(
                          name: 'map.json',
                          description:
                              'The level exported from Spritefusion: tile layers plus which tiles are solid. Loaded through the MAP_ONE constant.',
                        ),
                        FileNode(
                          name: 'spritesheet.png',
                          description:
                              'The tileset image map.json draws its tiles from.',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            FileNode(
              name: 'brass_key.png',
              description:
                  'A key sprite included for later lessons. Not used in the game yet.',
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
              'The entry point of the application. It runs the app and opens GameScreen.',
        ),
        FileNode(
          name: 'core',
          isDirectory: true,
          children: [
            FileNode(
              name: 'constants',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'globals.dart',
                  description:
                      'Shared constants: asset paths for backgrounds, characters and the map, plus attack animation names and timing.',
                ),
                FileNode(
                  name: 'character_asset.dart',
                  description:
                      'The CharacterAsset enum. Each value (wizard, shark) lists every sprite sheet and frame count one character needs.',
                ),
              ],
            ),
            FileNode(
              name: 'mixins',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'screen_boundary_checker.dart',
                  description:
                      'ScreenBoundaryChecker mixin that keeps a component inside the map.',
                ),
              ],
            ),
          ],
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
                      'ParallaxBackground: layered sky, clouds, mountains and hills that scroll at different speeds.',
                ),
              ],
            ),
            FileNode(
              name: 'characters',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'hero.dart',
                  description:
                      'The playable Hero: animations, gravity, collision, keyboard movement, jumping, and attacks.',
                ),
                FileNode(
                  name: 'util',
                  isDirectory: true,
                  children: [
                    FileNode(
                      name: 'animation_utils.dart',
                      description:
                          'AnimationUtils.loadAnimation turns a sprite sheet into a SpriteAnimation.',
                    ),
                  ],
                ),
              ],
            ),
            FileNode(
              name: 'screens',
              isDirectory: true,
              children: [
                FileNode(
                  name: 'game_screen.dart',
                  description:
                      'GameScreen builds the BonfireWidget: map, hero, background, camera, and keyboard controls.',
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    FileNode(
      name: 'test',
      isDirectory: true,
      children: [
        FileNode(
          name: 'character_asset_test.dart',
          description:
              'Checks every character sprite sheet exists and has the frame count CharacterAsset expects.',
        ),
      ],
    ),
    FileNode(
      name: 'pubspec.yaml',
      description:
          'Dependencies (bonfire) and the asset folders Flutter bundles with the game.',
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
