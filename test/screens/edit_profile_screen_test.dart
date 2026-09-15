import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/customer.dart';
import 'package:fundilink_app/screens/edit_profile_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

/// Finds the text field carrying [icon] as its prefix, so the tests do not
/// depend on the order of the fields.
Finder _field(IconData icon) =>
    find.ancestor(of: find.byIcon(icon), matching: find.byType(TextFormField));

void main() {
  Future<AppStore> pumpEditor(
    WidgetTester tester, {
    ValueChanged<CustomerProfile>? onSaved,
  }) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(
      tester,
      EditProfileScreen(onSaved: onSaved),
      store: store,
    );
    return store;
  }

  testWidgets('prefills the fields from the store', (tester) async {
    await pumpEditor(tester);

    expect(find.text('Amina Yusuf'), findsOneWidget);
    expect(find.text('amina.yusuf@example.com'), findsOneWidget);
    expect(find.text('+254 712 345 678'), findsOneWidget);
    expect(find.text('Kilimani, Nairobi'), findsOneWidget);
  });

  testWidgets('saving writes the edited details to the store', (tester) async {
    CustomerProfile? saved;
    final store = await pumpEditor(tester, onSaved: (p) => saved = p);

    await tester.enterText(_field(Icons.person_outline), 'Amina Y');
    await tester.enterText(_field(Icons.mail_outline), 'amina@fundilink.co.ke');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(store.profile.name, 'Amina Y');
    expect(store.profile.email, 'amina@fundilink.co.ke');
    expect(saved, store.profile);
  });

  testWidgets('trimmed input is what gets saved', (tester) async {
    final store = await pumpEditor(tester);

    await tester.enterText(_field(Icons.person_outline), '  Amina Y  ');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(store.profile.name, 'Amina Y');
  });

  testWidgets('an invalid email blocks the save', (tester) async {
    final store = await pumpEditor(tester);

    await tester.enterText(_field(Icons.mail_outline), 'not-an-email');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(store.profile, CustomerProfile.demo);
  });

  testWidgets('an empty name blocks the save', (tester) async {
    final store = await pumpEditor(tester);

    await tester.enterText(_field(Icons.person_outline), '');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your name'), findsOneWidget);
    expect(store.profile, CustomerProfile.demo);
  });

  testWidgets('a short phone number blocks the save', (tester) async {
    final store = await pumpEditor(tester);

    await tester.enterText(_field(Icons.phone_outlined), '0712');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid phone number'), findsOneWidget);
    expect(store.profile, CustomerProfile.demo);
  });
}
