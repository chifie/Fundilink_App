import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/models/fundi_extensions.dart';
import 'package:fundi_link/models/fundi_model.dart';

Fundi _fundi({double rating = 4.8, int responseTimeMinutes = 10}) {
  return Fundi(
    id: 'f1',
    fullName: 'James Otieno',
    categoryId: 'plumbing',
    categoryName: AppStrings.plumbing,
    description:
        'Certified plumber with over 8 years of experience fixing '
        'leaks, installing fixtures and unblocking drains across the city.',
    experienceYears: 8,
    location: 'Westlands',
    city: 'Nairobi',
    distanceKm: 2.4,
    rating: rating,
    ratingCount: 42,
    completedJobs: 130,
    startingPrice: 800,
    priceUnit: AppStrings.perJob,
    isAvailable: true,
    verified: true,
    responseTimeMinutes: responseTimeMinutes,
    serviceTags: const ['leaks', 'installations'],
    portfolioImages: const ['image1.jpg'],
  );
}

void main() {
  group('Fundi', () {
    test('stores the constructor values', () {
      final fundi = _fundi();
      expect(fundi.id, 'f1');
      expect(fundi.fullName, 'James Otieno');
      expect(fundi.categoryName, AppStrings.plumbing);
      expect(fundi.startingPrice, 800);
      expect(fundi.isAvailable, isTrue);
      expect(fundi.verified, isTrue);
    });

    test('defaults to unverified with no tags or portfolio', () {
      const fundi = Fundi(
        id: 'f2',
        fullName: 'Ana Wanjiru',
        categoryId: 'cleaning',
        categoryName: AppStrings.cleaning,
        description: 'Deep cleaning expert.',
        experienceYears: 3,
        location: 'Kilimani',
        city: 'Nairobi',
        distanceKm: 5.0,
        rating: 4.2,
        ratingCount: 10,
        completedJobs: 20,
        startingPrice: 500,
        priceUnit: AppStrings.perJob,
        isAvailable: false,
      );
      expect(fundi.verified, isFalse);
      expect(fundi.serviceTags, isEmpty);
      expect(fundi.portfolioImages, isEmpty);
    });
  });

  group('FundiHelpers', () {
    test('hasPortfolio and hasServiceTags reflect the lists', () {
      final fundi = _fundi();
      expect(fundi.hasPortfolio, isTrue);
      expect(fundi.hasServiceTags, isTrue);
    });

    test('priceDisplay combines the amount and unit', () {
      expect(_fundi().priceDisplay, 'KES 800/job');
    });

    test('shortDescription truncates long descriptions', () {
      final fundi = _fundi();
      expect(fundi.shortDescription.length, 100);
      expect(fundi.shortDescription.endsWith('...'), isTrue);
    });

    test('ratingDisplay formats the rating to one decimal', () {
      expect(_fundi(rating: 4.75).ratingDisplay, '4.8');
    });

    test('isHighlyRated requires a rating of 4.5 or higher', () {
      expect(_fundi(rating: 4.8).isHighlyRated, isTrue);
      expect(_fundi(rating: 4.2).isHighlyRated, isFalse);
    });

    test('ratingTierColor maps rating bands to badge colors', () {
      expect(_fundi(rating: 4.9).ratingTierColor, const Color(0xFF7193A3));
      expect(_fundi(rating: 4.6).ratingTierColor, const Color(0xFF10B981));
      expect(_fundi(rating: 4.2).ratingTierColor, const Color(0xFFF59E0B));
      expect(_fundi(rating: 3.8).ratingTierColor, const Color(0xFFEF4444));
    });

    test('isFastResponder is true for 15 minutes or less', () {
      expect(_fundi(responseTimeMinutes: 15).isFastResponder, isTrue);
      expect(_fundi(responseTimeMinutes: 20).isFastResponder, isFalse);
    });
  });
}
