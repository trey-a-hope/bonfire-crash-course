import 'dart:ui';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that displays an image with an optional caption.
///
/// Clicking the image opens an interactive, enlarged view using a smooth [Hero] animation.
class HeroImage extends StatefulWidget {
  final String imagePath;
  final String caption;
  final Object? heroTag;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const HeroImage({
    super.key,
    required this.imagePath,
    required this.caption,
    this.heroTag,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  /// Programmatically opens the enlarged image viewer with a [Hero] transition.
  static Future<void> showEnlarged(
    BuildContext context, {
    required String imagePath,
    String caption = '',
    Object? heroTag,
  }) {
    final effectiveHeroTag = heroTag ?? UniqueKey();

    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return EnlargedImageViewer(
            imagePath: imagePath,
            caption: caption,
            heroTag: effectiveHeroTag,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  bool _isHovered = false;

  late final Object _effectiveHeroTag = widget.heroTag ?? UniqueKey();

  void _openEnlarged() {
    HeroImage.showEnlarged(
      context,
      imagePath: widget.imagePath,
      caption: widget.caption,
      heroTag: _effectiveHeroTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openEnlarged,
            child: Tooltip(
              message: 'Click to expand image',
              waitDuration: const Duration(milliseconds: 500),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: _isHovered
                        ? Colors.blueAccent.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.12),
                    width: _isHovered ? 1.5 : 1.0,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.25),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: _effectiveHeroTag,
                        flightShuttleBuilder: _flightShuttleBuilder,
                        child: Image.asset(
                          widget.imagePath,
                          width: widget.width,
                          height: widget.height,
                          fit: widget.fit,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.fullscreen_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.caption.trim().isNotEmpty) ...[
          GapSizes.xsGap,
          Text(
            widget.caption,
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  static Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero toHero = toHeroContext.widget as Hero;
    return Material(type: MaterialType.transparency, child: toHero.child);
  }
}

/// The modal dialog widget that displays the enlarged image with zoom, pan, and caption.
class EnlargedImageViewer extends StatelessWidget {
  final String imagePath;
  final String caption;
  final Object heroTag;

  const EnlargedImageViewer({
    super.key,
    required this.imagePath,
    required this.caption,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).pop();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Tap backdrop to dismiss
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.82),
                    ),
                  ),
                ),
              ),
              // Enlarged image & caption centered
              Center(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.88,
                              maxHeight: size.height * 0.78,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 32,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: InteractiveViewer(
                                  clipBehavior: Clip.hardEdge,
                                  minScale: 1.0,
                                  maxScale: 4.0,
                                  child: Hero(
                                    tag: heroTag,
                                    flightShuttleBuilder:
                                        (
                                          flightContext,
                                          animation,
                                          flightDirection,
                                          fromHeroContext,
                                          toHeroContext,
                                        ) {
                                          final Hero toHero =
                                              toHeroContext.widget as Hero;
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: toHero.child,
                                          );
                                        },
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (caption.trim().isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.80,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              caption,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Top-right close button
              Positioned(
                top: 24,
                right: 24,
                child: SafeArea(
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'Close (Esc)',
                      splashRadius: 22,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              // Hint indicator for zoom
              Positioned(
                bottom: 24,
                right: 24,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pinch_rounded,
                          size: 14,
                          color: Colors.white60,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Scroll / pinch to zoom',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
