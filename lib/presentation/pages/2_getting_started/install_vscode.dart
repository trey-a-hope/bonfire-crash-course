import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/widgets/comparison_row.dart';
import 'package:bonfire_crash_course/presentation/widgets/extension_row.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/platform_chip.dart';
import 'package:bonfire_crash_course/presentation/widgets/step_badge_header.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstallVSCode extends StatefulWidget {
  const InstallVSCode({super.key});

  @override
  State<InstallVSCode> createState() => _InstallVSCodeState();
}

class _InstallVSCodeState extends State<InstallVSCode> {
  late var _showMacOs = PlatformResolver.isMacOS;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Badge & Header
        const StepBadgeHeader(
          title: 'GETTING STARTED',
          currentStep: 3,
          totalSteps: 4,
          color: Colors.purpleAccent,
          extra: 'OPTIONAL LOCAL SETUP',
        ),
        GapSizes.smallGap,
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
                            GapSizes.mediumGap,
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
                                  GapSizes.xsGap,
                                  Text(
                                    'Installing VS Code locally is not required to complete this course. If you completed Step 2 (Create a Codespace), your browser already has full VS Code running in the cloud with Flutter and Bonfire pre-installed. Only follow this page if you want to develop offline.',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
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
                                    GapSizes.smallGap,
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
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PlatformChip(
                                        title: 'macOS',
                                        isSelected: _showMacOs,
                                        onTap: () =>
                                            setState(() => _showMacOs = true),
                                      ),
                                      PlatformChip(
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
                              child: GlassButton(
                                prefixIconData: _showMacOs
                                    ? Icons.apple
                                    : Icons.desktop_windows_rounded,
                                title: _showMacOs
                                    ? 'Download for macOS'
                                    : 'Download for Windows',
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
                                color: Colors.tealAccent,
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
                                GapSizes.smallGap,
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
                            const ExtensionRow(
                              name: 'Flutter',
                              publisher: 'flutter.dev',
                              description:
                                  'Adds Flutter debugging, run without debug, and hot reload.',
                            ),
                            GapSizes.smallGap,
                            const ExtensionRow(
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
                                    color: Colors.purpleAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.laptop_chromebook_rounded,
                                    color: Colors.purpleAccent,
                                    size: 18,
                                  ),
                                ),
                                GapSizes.smallGap,
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
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
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
                            const ComparisonRow(
                              label: 'Setup Time',
                              cloud: 'Instant (0 mins)',
                              local: '~15-20 mins',
                            ),
                            const ComparisonRow(
                              label: 'Disk Space',
                              cloud: '0 GB on your PC',
                              local: '~10-15 GB SDKs',
                            ),
                            const ComparisonRow(
                              label: 'Offline Work',
                              cloud: 'Needs internet',
                              local: 'Fully offline',
                            ),
                            const ComparisonRow(
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
}
