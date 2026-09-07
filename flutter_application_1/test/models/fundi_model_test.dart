import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/fundi_model.dart';

void main() {
  group('Fundi.hasRemoteAvatar', () {
    test('returns true for an http avatar', () {
      const fundi = Fundi(
        id: 'f1',
        fullName: 'James Otieno',
        avatarUrl: 'https://example.com/avatar.png',
        categoryId: 'cat_plumbing',
        categoryName: 'Plumbing',
        description: 'Plumber',
        experienceYears: 8,
        location: 'Nairobi',
        city: 'Nairobi',
        distanceKm: 2.0,
        rating: 4.8,
        ratingCount: 100,
        completedJobs: 100,
        startingPrice: 800,
        priceUnit: '/job',
        isAvailable: true,
      );
      expect(fundi.hasRemoteAvatar, isTrue);
    });

    test('returns false for a local asset path', () {
      const fundi = Fundi(
        id: 'f2',
        fullName: 'Mary Wanjiku',
        avatarUrl: 'assets/avatars/mary.png',
        categoryId: 'cat_electrical',
        categoryName: 'Electrical',
        description: 'Electrician',
        experienceYears: 6,
        location: 'Nairobi',
        city: 'Nairobi',
        distanceKm: 1.8,
        rating: 4.9,
        ratingCount: 168,
        completedJobs: 168,
        startingPrice: 1200,
        priceUnit: '/hour',
        isAvailable: true,
      );
      expect(fundi.hasRemoteAvatar, isFalse);
    });

    test('returns false when avatar is null', () {
      const fundi = Fundi(
        id: 'f3',
        fullName: 'Peter Kiprono',
        categoryId: 'cat_carpentry',
        categoryName: 'Carpentry',
        description: 'Carpenter',
        experienceYears: 10,
        location: 'Ruiru',
        city: 'Kiambu',
        distanceKm: 5.2,
        rating: 4.6,
        ratingCount: 143,
        completedJobs: 143,
        startingPrice: 1500,
        priceUnit: '/job',
        isAvailable: true,
      );
      expect(fundi.hasRemoteAvatar, isFalse);
    });
  });

  group('Fundi.tagline', () {
    test('joins the first three service tags', () {
      const fundi = Fundi(
        id: 'f1',
        fullName: 'James Otieno',
        categoryId: 'cat_plumbing',
        categoryName: 'Plumbing',
        description: 'Plumber',
        experienceYears: 8,
        location: 'Nairobi',
        city: 'Nairobi',
        distanceKm: 2.0,
        rating: 4.8,
        ratingCount: 100,
        completedJobs: 100,
        startingPrice: 800,
        priceUnit: '/job',
        isAvailable: true,
        serviceTags: ['Leaks', 'Pipes', 'Water Heaters', 'Drainage'],
      );
      expect(fundi.tagline, 'Leaks, Pipes, Water Heaters');
    });

    test('returns an empty string when there are no tags', () {
      const fundi = Fundi(
        id: 'f1',
        fullName: 'James Otieno',
        categoryId: 'cat_plumbing',
        categoryName: 'Plumbing',
        description: 'Plumber',
        experienceYears: 8,
        location: 'Nairobi',
        city: 'Nairobi',
        distanceKm: 2.0,
        rating: 4.8,
        ratingCount: 100,
        completedJobs: 100,
        startingPrice: 800,
        priceUnit: '/job',
        isAvailable: true,
        serviceTags: [],
      );
      expect(fundi.tagline, isEmpty);
    });
  });
}
