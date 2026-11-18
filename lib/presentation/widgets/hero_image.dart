import 'dart:ui';

import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An asset image (PNG, JPG or SVG) with an optional caption.
///
/// Clicking it opens an enlarged, zoomable view with a [Hero] animation.
/// Close it with Esc, the close button, or a click outside the image.
class HeroImage extends StatefulWidget {
  final String imagePath;
  final String caption;
  final Object? heroTag;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  /// Painted behind the image, here and in the enlarged view. Useful for
  /// SVGs drawn for a light background.
  final Color? backgroundColor;

  /// Read by screen readers.
  final String? semanticsLabel;

  const HeroImage({
    super.key,
    required this.imagePath,
    this.caption = '',
    this.heroTag,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor,
    this.semanticsLabel,
  });

  /// Builds the image for [imagePath], using [SvgPicture] for `.svg` files.
  static Widget buildImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    if (imagePath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        semanticsLabel: semanticsLabel,
      );
    }
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticsLabel,
    );
  }

  /// Opens the enlarged image viewer with a [Hero] transition.
  static Future<void> showEnlarged(
    BuildContext context, {
    required String imagePath,
    String caption = '',
    Object? heroTag,
    Color? backgroundColor,
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
            backgroundColor: backgroundColor,
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
      backgroundColor: widget.backgroundColor,
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
                  color: widget.backgroundColor,
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
                  // Passthrough keeps the box's width for the image, so it
                  // fills the card instead of shrinking to its own size.
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    children: [
                      Hero(
                        tag: _effectiveHeroTag,
                        flightShuttleBuilder: _flightShuttleBuilder,
                        child: HeroImage.buildImage(
                          widget.imagePath,
                          fit: widget.fit,
                          semanticsLabel: widget.semanticsLabel,
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
}

Widget _flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final Hero toHero = toHeroContext.widget as Hero;
  return Material(type: MaterialType.transparency, child: toHero.child);
}

/// The full-window view: the enlarged image with zoom, pan and caption.
class EnlargedImageViewer extends StatelessWidget {
  final String imagePath;
  final String caption;
  final Object heroTag;
  final Color? backgroundColor;

  const EnlargedImageViewer({
    super.key,
    required this.imagePath,
    required this.caption,
    required this.heroTag,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

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
              // Click the backdrop to close.
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
              // Enlarged image and caption, centered.
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
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.6),
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
                                  flightShuttleBuilder: _flightShuttleBuilder,
                                  child: HeroImage.buildImage(imagePath),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (caption.trim().isNotEmpty) ...[
                          GapSizes.mediumGap,
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
                            ),
                            child: Text(
                              caption,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
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
              // Close button, top right.
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              // Zoom hint, bottom right.
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pinch_rounded,
                          size: 14,
                          color: Colors.white60,
                        ),
                        GapSizes.smallGap,
                        Text(
                          'Scroll / pinch to zoom',
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white60,
                          ),
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
