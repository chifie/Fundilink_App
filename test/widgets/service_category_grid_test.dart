import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/widgets/service_category_grid.dart';

void main() {
  testWidgets('shows one tile per service skill', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ServiceCategoryGrid())),
    );

    for (final skill in FundiSkill.values) {
      expect(find.text(skill.label), findsOneWidget);
    }
  });

  testWidgets('reports tapped category', (tester) async {
    FundiSkill? tapped;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceCategoryGrid(onTap: (skill) => tapped = skill),
        ),
      ),
    );

    await tester.tap(find.text('Plumbing'));
    expect(tapped, FundiSkill.plumbing);
  });
}
