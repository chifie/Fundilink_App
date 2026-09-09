import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/size_utils.dart';

void main() {
  group('SizeUtils', () {
    Future<T> run<T>(
      WidgetTester tester,
      Size size,
      T Function(BuildContext) fn,
    ) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      late T result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = fn(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      return result;
    }

    testWidgets('screenWidth reports the surface width', (tester) async {
      final width = await run(tester, const Size(400, 800), SizeUtils.screenWidth);
      expect(width, 400);
    });

    testWidgets('responsivePadding adapts to small, medium and large widths',
        (tester) async {
      final small = await run(
        tester,
        const Size(320, 640),
        (c) => SizeUtils.responsivePadding(c),
      );
      expect(small, 12);

      final medium = await run(
        tester,
        const Size(400, 800),
        (c) => SizeUtils.responsivePadding(c),
      );
      expect(medium, 16);

      final large = await run(
        tester,
        const Size(900, 1200),
        (c) => SizeUtils.responsivePadding(c),
      );
      expect(large, 24);
    });

    testWidgets('screenDiagonal matches the Pythagorean calculation',
        (tester) async {
      final diagonal = await run(
        tester,
        const Size(300, 400),
        SizeUtils.screenDiagonal,
      );
      expect(diagonal, closeTo(500, 0.01));
    });

    testWidgets('screen classification helpers', (tester) async {
      final small = await run(
        tester,
        const Size(320, 640),
        SizeUtils.isSmallScreen,
      );
      expect(small, isTrue);

      final medium = await run(
        tester,
        const Size(500, 800),
        SizeUtils.isMediumScreen,
      );
      expect(medium, isTrue);

      final large = await run(
        tester,
        const Size(1000, 800),
        SizeUtils.isLargeScreen,
      );
      expect(large, isTrue);
    });
  });
}