import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstallVSCode extends StatefulWidget {
  const InstallVSCode({super.key});

  @override
  State<InstallVSCode> createState() => _InstallVSCodeState();
}

class _InstallVSCodeState extends State<InstallVSCode> {
  late bool _showMacOs = PlatformResolver.isMacOS;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Badge & Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.purpleAccent.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                'GETTING STARTED • STEP 3 OF 4',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'OPTIONAL LOCAL SETUP',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Install VS Code (Optional)',
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.xsGap,
        Text(
          'Set up Visual Studio Code locally if you prefer coding offline rather than using GitHub Codespaces.',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        GapSizes.largeGap,

        // Main Split Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Instructions & Platform Installer (Flex 3)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Why is this step optional?" Callout
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.cyanAccent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.cyanAccent,
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Why is this step optional?',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Installing VS Code locally is not required to complete this course. If you completed Step 2 (Create a Codespace), your browser already has full VS Code running in the cloud with Flutter and Bonfire pre-installed. Only follow this page if you want to develop offline.',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GapSizes.largeGap,

                      // Platform Installation Card with Switchable Tabs
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Platform Selector Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _showMacOs
                                          ? Icons.apple
                                          : Icons.desktop_windows_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _showMacOs
                                          ? 'macOS Installation Steps'
                                          : 'Windows Installation Steps',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // OS Toggle Tabs
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildPlatformChip(
                                        title: 'macOS',
                                        isSelected: _showMacOs,
                                        onTap: () =>
                                            setState(() => _showMacOs = true),
                                      ),
                                      _buildPlatformChip(
                                        title: 'Windows',
                                        isSelected: !_showMacOs,
                                        onTap: () =>
                                            setState(() => _showMacOs = false),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.mediumGap,

                            // Steps widget based on active platform
                            if (_showMacOs)
                              const StepsWidget.simple(
                                steps: [
                                  'Click "Download for macOS" below to download the universal installer zip.',
                                  'Locate the downloaded zip in your Downloads folder and extract Visual Studio Code.app.',
                                  'Drag Visual Studio Code.app into your Applications folder so it is available from Spotlight.',
                                  'Launch VS Code and approve the macOS security confirmation dialog on first launch.',
                                ],
                              )
                            else
                              const StepsWidget.simple(
                                steps: [
                                  'Click "Download for Windows" below to download the official user installer .exe.',
                                  'Run the downloaded installer and accept the Microsoft software license agreement.',
                                  'On the Additional Tasks screen, check "Add to PATH" and "Register Code as editor".',
                                  'Click Install, then Finish to open Visual Studio Code on your Windows machine.',
                                ],
                              ),

                            GapSizes.largeGap,

                            // Download Action Button
                            Center(
                              child: AdaptiveButton(
                                type: AdaptiveButtonType.filled,
                                onPressed: () async {
                                  final url = _showMacOs
                                      ? VSCODE_DOWNLOAD_MACOS
                                      : VSCODE_DOWNLOAD_WINDOWS;
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _showMacOs
                                          ? Icons.apple
                                          : Icons.desktop_windows_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    GapSizes.smallGap,
                                    Text(
                                      _showMacOs
                                          ? 'Download for macOS'
                                          : 'Download for Windows',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GapSizes.largeGap,

                      // Recommended Extensions Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.extension_rounded,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Required Local Extensions',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.smallGap,
                            Text(
                              'Once VS Code is installed locally, open the Extensions sidebar (Ctrl/Cmd + Shift + X) and install these two extensions to run the Bonfire course:',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                            GapSizes.mediumGap,
                            _buildExtensionRow(
                              context,
                              name: 'Flutter',
                              publisher: 'flutter.dev',
                              description:
                                  'Adds Flutter debugging, run without debug, and hot reload.',
                            ),
                            const SizedBox(height: 10),
                            _buildExtensionRow(
                              context,
                              name: 'Dart',
                              publisher: 'dart-code.org',
                              description:
                                  'Provides syntax highlighting, code completion, and linting.',
                            ),
                          ],
                        ),
                      ),
                      GapSizes.largeGap,
                    ],
                  ),
                ),
              ),
              GapSizes.largeGap,

              // Right Column: Visual Preview & Cloud vs Local Comparison (Flex 2)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Visual Walkthrough Container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.laptop_chromebook_rounded,
                                    color: Colors.purpleAccent,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'VS Code in Action',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Click screenshot to zoom',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.mediumGap,
                            const HeroImage(
                              imagePath:
                                  'assets/images/screenshots/2/run_app.png',
                              caption:
                                  'Visual Studio Code running the course project',
                            ),
                          ],
                        ),
                      ),
                      GapSizes.mediumGap,

                      // Cloud vs Local Comparison Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cloud vs. Local Setup',
                              style: textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GapSizes.smallGap,
                            _buildComparisonRow(
                              context,
                              label: 'Setup Time',
                              cloud: 'Instant (0 mins)',
                              local: '~15-20 mins',
                            ),
                            _buildComparisonRow(
                              context,
                              label: 'Disk Space',
                              cloud: '0 GB on your PC',
                              local: '~10-15 GB SDKs',
                            ),
                            _buildComparisonRow(
                              context,
                              label: 'Offline Work',
                              cloud: 'Needs internet',
                              local: 'Fully offline',
                            ),
                            _buildComparisonRow(
                              context,
                              label: 'Device Specs',
                              cloud: 'Any laptop/tablet',
                              local: 'Standard PC / Mac',
                            ),
                          ],
                        ),
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

  Widget _buildPlatformChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.35)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildExtensionRow(
    BuildContext context, {
    required String name,
    required String publisher,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.extension_outlined,
            color: Colors.blueAccent,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'by $publisher',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(
    BuildContext context, {
    required String label,
    required String cloud,
    required String local,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              cloud,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              local,
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
