import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton_widget.dart';

class ProductListItemSkeleton extends StatelessWidget {
  const ProductListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine border color for dark mode (Slate 700) to match existing card style
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark
            ? const BorderSide(color: Color(0xFF334155), width: 1)
            : BorderSide.none,
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report No Badge
            SkeletonWidget(
              width: 80,
              height: 18,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            SizedBox(height: 12),

            // Product Name Line 1
            SkeletonWidget(
              width: double.infinity,
              height: 20,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            SizedBox(height: 8),

            // Product Name Line 2 (Shorter)
            SkeletonWidget(
              width: 150,
              height: 20,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            SizedBox(height: 16),

            // Ingredients Line 1
            SkeletonWidget(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            SizedBox(height: 6),

            // Ingredients Line 2
            SkeletonWidget(
              width: 200,
              height: 14,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}
