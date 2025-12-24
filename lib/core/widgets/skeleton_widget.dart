import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const SkeletonWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode colors (Slate 200 base, Slate 100 highlight)
    final lightBase = Colors.grey[300]!;
    final lightHighlight = Colors.grey[100]!;

    // Dark mode colors (Slate 700 base, Slate 600 highlight)
    final darkBase = const Color(0xFF334155);
    final darkHighlight = const Color(0xFF475569);

    return Shimmer.fromColors(
      baseColor: isDark ? darkBase : lightBase,
      highlightColor: isDark ? darkHighlight : lightHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? darkBase : lightBase,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? (borderRadius ?? BorderRadius.circular(8))
              : null,
        ),
      ),
    );
  }
}
