import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/models/review.dart';
import 'package:fundi_link/models/service_request.dart';

ServiceRequest _request({RequestStatus status = RequestStatus.pending}) {
  return ServiceRequest(
    id: 'r1',
    customerId: 'u1',
    customerName: 'Brian Kimani',
    fundiId: 'f1',
    fundiName: 'James Otieno',
    categoryId: 'plumbing',
    categoryName: AppStrings.plumbing,
    description: 'Kitchen sink is leaking.',
    status: status,
    preferredDate: 'Sep 10',
    preferredTime: '2:00 PM',
    location: 'Westlands',
    estimatedCost: 1200,
    createdAt: DateTime(2026, 9, 5),
  );
}

void main() {
  group('RequestStatusX', () {
    test('label returns the user-facing status text', () {
      expect(RequestStatus.pending.label, AppStrings.pending);
      expect(RequestStatus.inProgress.label, AppStrings.inProgress);
      expect(RequestStatus.rejected.label, AppStrings.rejected);
    });

    test('color and lightColor return material colors', () {
      for (final status in RequestStatus.values) {
        expect(status.color, isA<Color>());
        expect(status.lightColor, isA<Color>());
        expect(status.icon, isA<IconData>());
      }
    });
  });

  group('requestStatusFromName', () {
    test('maps a valid enum name back to its status', () {
      expect(requestStatusFromName('completed'), RequestStatus.completed);
      expect(requestStatusFromName('accepted'), RequestStatus.accepted);
    });

    test('falls back to pending for unknown names', () {
      expect(requestStatusFromName('cancelled'), RequestStatus.pending);
    });
  });

  group('ServiceRequest', () {
    test('stores the constructor values', () {
      final request = _request();
      expect(request.id, 'r1');
      expect(request.customerName, 'Brian Kimani');
      expect(request.status, RequestStatus.pending);
      expect(request.estimatedCost, 1200);
    });

    test('copyWith updates only the provided fields', () {
      final request = _request();
      final updated = request.copyWith(
        status: RequestStatus.accepted,
        estimatedCost: 1500,
      );

      expect(updated.status, RequestStatus.accepted);
      expect(updated.estimatedCost, 1500);
      expect(updated.id, request.id);
      expect(updated.description, request.description);
      expect(updated.createdAt, request.createdAt);
      expect(updated.updatedAt, isNull);
    });

    test('copyWith carries over an existing updatedAt', () {
      final stamp = DateTime(2026, 9, 6);
      final request =
          _request().copyWith(status: RequestStatus.accepted).copyWith(updatedAt: stamp);
      expect(request.updatedAt, stamp);
    });
  });

  group('Review', () {
    test('stores rating, comment and customer name', () {
      final review = Review(
        id: 'rev1',
        fundiId: 'f1',
        customerName: 'Brian Kimani',
        rating: 5,
        comment: 'Excellent work!',
        createdAt: DateTime(2026, 9, 6),
      );
      expect(review.fundiId, 'f1');
      expect(review.rating, 5);
      expect(review.comment, 'Excellent work!');
      expect(review.createdAt, DateTime(2026, 9, 6));
    });
  });
}