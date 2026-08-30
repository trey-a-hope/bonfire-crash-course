import 'package:gap/gap.dart';

/// A utility class providing predefined, const Gap widgets for consistent spacing.
/// Usage: Use in Columns, Rows, or other Flex layouts, e.g., GapSizes.smallGap.
class GapSizes {
  // Private constructor to prevent instantiation.
  const GapSizes._();

  /// Extra small gap: 4 logical pixels.
  static const xsGap = Gap(4);

  /// Small gap: 8 logical pixels.
  static const smallGap = Gap(8);

  /// Medium gap: 16 logical pixels.
  static const mediumGap = Gap(16);

  /// Large gap: 24 logical pixels.
  static const largeGap = Gap(24);

  /// Extra large gap: 32 logical pixels.
  static const xlGap = Gap(32);
}
