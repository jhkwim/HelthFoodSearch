import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/core/widgets/skeleton_widget.dart';
import 'package:health_food_search/features/search/presentation/widgets/product_list_skeleton.dart';

void main() {
  testWidgets('SkeletonWidget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonWidget(width: 100, height: 20)),
      ),
    );

    expect(find.byType(SkeletonWidget), findsOneWidget);
  });

  testWidgets('ProductListItemSkeleton renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ProductListItemSkeleton())),
    );

    expect(find.byType(ProductListItemSkeleton), findsOneWidget);
    // Should find multiple SkeletonWidgets inside
    expect(find.byType(SkeletonWidget), findsWidgets);
  });
}
