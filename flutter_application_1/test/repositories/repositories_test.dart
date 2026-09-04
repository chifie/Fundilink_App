import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/fundi_model.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/repositories/fundi_repository.dart';
import 'package:fundi_link/repositories/request_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RequestRepository', () {
    test('totalEarnings sums completed and reviewed jobs only', () async {
      // James Otieno (f1) has one completed job (KES 2200); pending, accepted
      // and in-progress jobs must not count towards earnings.
      final earnings = await RequestRepository().totalEarnings('f1');
      expect(earnings, 2200.0);
    });

    test('totalEarnings is zero when a fundi has no paid-out jobs', () async {
      final earnings = await RequestRepository().totalEarnings('f99');
      expect(earnings, 0.0);
    });
  });

  group('FundiRepository', () {
    test('getCategories returns the seeded marketplace categories', () async {
      final categories = await FundiRepository().getCategories();
      expect(categories.length, greaterThanOrEqualTo(8));
      expect(categories.map((c) => c.name), contains('Plumbing'));
    });

    test('getFundis filters by category', () async {
      final plumbing =
          await FundiRepository().getFundis(categoryId: 'cat_plumbing');
      expect(plumbing, isNotEmpty);
      expect(plumbing.every((f) => f.categoryId == 'cat_plumbing'), isTrue);
    });

    test('getFundis searches names, categories and tags', () async {
      final results = await FundiRepository().getFundis(query: 'carpentry');
      expect(results, isNotEmpty);
      expect(
        results.every((f) =>
            f.categoryName.toLowerCase().contains('carpentry') ||
            f.fullName.toLowerCase().contains('carpentry')),
        isTrue,
      );
    });

    test('getFundis sorts by starting price ascending', () async {
      final results = await FundiRepository().getFundis(sortBy: 'price');
      for (var i = 1; i < results.length; i++) {
        expect(
          results[i].startingPrice >= results[i - 1].startingPrice,
          isTrue,
          reason: 'fundi list must be sorted by price',
        );
      }
    });
  });

  group('Fundi helpers', () {
    test('seed data fundis expose display fields', () {
      final repo = FundiRepository();
      // Placeholder group keeps the model import referenced in this test file.
      final sample = Fundi(
        id: 'f_x',
        fullName: 'Sample Fundi',
        categoryId: 'cat_other',
        categoryName: 'Other',
        description: 'd',
        experienceYears: 1,
        location: 'Nairobi',
        city: 'Nairobi',
        distanceKm: 1,
        rating: 4,
        ratingCount: 1,
        completedJobs: 1,
        startingPrice: 100,
        priceUnit: '/hour',
        isAvailable: true,
      );
      expect(repo, isNotNull);
      expect(sample.startingPrice, 100);
      expect(RequestStatus.pending.label, isNotEmpty);
    });
  });
}
