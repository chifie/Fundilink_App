import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/auth/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpOnboarding(
    WidgetTester tester, {
    required VoidCallback onComplete,
  }) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      MaterialApp(home: OnboardingScreen(onComplete: onComplete)),
    );
  }

  Future<bool> seenValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('fundilink_onboarding_seen') ?? false;
  }

  testWidgets('shows the first page with Next', (tester) async {
    await pumpOnboarding(tester, onComplete: () {});

    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
    expect(find.text(AppStrings.next), findsOneWidget);
    expect(find.text(AppStrings.skip), findsOneWidget);
  });

  testWidgets('finishing through the pages calls onComplete and marks seen', (
    tester,
  ) async {
    var completed = false;
    await pumpOnboarding(tester, onComplete: () => completed = true);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingTitle2), findsOneWidget);

    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingTitle3), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(await seenValue(), isTrue);
  });

  testWidgets('skipping immediately marks onboarding as seen', (tester) async {
    var completed = false;
    await pumpOnboarding(tester, onComplete: () => completed = true);

    await tester.tap(find.text(AppStrings.skip));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(await seenValue(), isTrue);
  });
}
