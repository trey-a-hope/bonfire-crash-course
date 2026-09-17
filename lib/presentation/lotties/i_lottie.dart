import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// An abstract base widget for standardized Lottie animations across the application.
///
/// Subclasses provide a concrete [lottieUrl] pointing to remote JSON animation assets
/// (such as hero graphics or lesson header illustrations), while inheriting unified
/// sizing and scaling defaults.
abstract class ILottie extends StatelessWidget {
  /// The height constraint applied to the animation canvas.
  final double? height;

  /// The width constraint applied to the animation canvas.
  final double? width;

  /// How the animation is scaled to fit within its allocated bounding box.
  final BoxFit fit;

  /// Creates a reusable [ILottie] animation widget.
  const ILottie({
    super.key,
    this.height = 200,
    this.width,
    this.fit = BoxFit.contain,
  });

  /// The remote network URL delivering the Lottie JSON asset.
  String get lottieUrl;

  @override
  Widget build(BuildContext context) {
    return Lottie.network(lottieUrl, height: height, width: width, fit: fit);
  }
}
