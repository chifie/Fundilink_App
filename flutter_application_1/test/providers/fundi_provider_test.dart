import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/data/mock_data.dart';
import 'package:fundi_link/providers/fundi_provider.dart';

void main() {
  group('FundiProvider catalog', () {
    test('loadCategories loads the seeded marketplace categories', () async {
      final provider = FundiProvider();
      await provider.loadCategories();

      expect(provider.categories, isNotEmpty);
      expect(provider.categories.length, MockData.categories.length);
    });

    test('loadFundis exposes the full fundi directory', () async {
      final provider = FundiProvider();
      await provider.loadFundis();

      expect(provider.fundis.length, MockData.fundis.length);
      expect(provider.isLoading, isFalse);
    });
  });

  group('FundiProvider search and filtering', () {
    test('search matches the category name across fundis', () async {
      final provider = FundiProvider();
      await provider.loadFundis(query: 'plumbing');

      expect(provider.fundis, isNotEmpty);
      expect(
        provider.fundis.every((f) => f.categoryId == 'cat_plumbing'),
        isTrue,
      );
    });

    test('filterByCategory narrows to one category', () async {
      final provider = FundiProvider();
      await provider.filterByCategory('cat_carpentry');

      expect(provider.fundis, isNotEmpty);
      expect(
        provider.fundis.every((f) => f.categoryId == 'cat_carpentry'),
        isTrue,
      );
    });
  });

  group('FundiProvider curated lists', () {
    test('recommended returns at most four fundis sorted by rating', () async {
      final provider = FundiProvider();
      await provider.loadFundis();

      final recommended = provider.recommended;
      expect(recommended.length, lessThanOrEqualTo(4));
      for (var i = 1; i < recommended.length; i++) {
        expect(
          recommended[i - 1].rating >= recommended[i].rating,
          isTrue,
          reason: 'recommended fundis must be sorted by rating',
        );
      }
    });

    test('nearby returns the closest fundis first', () async {
      final provider = FundiProvider();
      await provider.loadFundis();

      final nearby = provider.nearby;
      expect(nearby, isNotEmpty);
      for (var i = 1; i < nearby.length; i++) {
        expect(
          nearby[i - 1].distanceKm <= nearby[i].distanceKm,
          isTrue,
          reason: 'nearby fundis must be sorted by distance',
        );
      }
    });
  });

  group('FundiProvider lookups', () {
    test('fundiById finds a seeded fundi and falls back to null', () async {
      final provider = FundiProvider();
      await provider.loadFundis();

      expect(provider.fundiById('f1')?.fullName, 'James Otieno');
      expect(provider.fundiById('does-not-exist'), isNull);
    });

    test(
      'portfolioFor and availabilityFor delegate to the mock store',
      () async {
        final provider = FundiProvider();
        final portfolio = await provider.portfolioFor('f1');
        final availability = await provider.availabilityFor('f1');

        expect(portfolio, isNotEmpty);
        expect(portfolio.every((p) => p.fundiId == 'f1'), isTrue);
        expect(availability.fundiId, 'f1');
        expect(availability.isAvailable, isTrue);
      },
    );
  });
}
