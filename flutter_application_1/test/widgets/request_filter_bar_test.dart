import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/widgets/requests/request_filter_bar.dart';

void main() {
  group('RequestFilter', () {
    group('label', () {
      test('returns the correct AppStrings label for each filter', () {
        expect(RequestFilter.all.label, AppStrings.all);
        expect(RequestFilter.pending.label, AppStrings.pending);
        expect(RequestFilter.active.label, AppStrings.inProgress);
        expect(RequestFilter.completed.label, AppStrings.completed);
      });
    });

    group('apply', () {
      late final List<ServiceRequest> requests;

      setUp(() {
        requests = [
          _pendingRequest(),
          _acceptedRequest(),
          _inProgressRequest(),
          _completedRequest(),
          _reviewedRequest(),
        ];
      });

      test('returns all requests for the all filter', () {
        final result = RequestFilter.all.apply(requests);
        expect(result.length, requests.length);
      });

      test('returns only pending requests for the pending filter', () {
        final result = RequestFilter.pending.apply(requests);
        expect(result.every((r) => r.status == RequestStatus.pending), isTrue);
        expect(result.length, 1);
      });

      test('returns only active requests for the active filter', () {
        final result = RequestFilter.active.apply(requests);
        expect(
          result.every((r) => r.status.isActive),
          isTrue,
        );
        expect(result.length, 2);
      });

      test('returns only paid-out requests for the completed filter', () {
        final result = RequestFilter.completed.apply(requests);
        expect(
          result.every((r) => r.status.isPaidOut),
          isTrue,
        );
        expect(result.length, 2);
      });
    });
  });
}

ServiceRequest _pendingRequest() => ServiceRequest(
      id: 'r1',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: 'Plumbing',
      description: 'Fix leak',
      status: RequestStatus.pending,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'Nairobi',
      createdAt: DateTime(2026, 9, 6),
    );

ServiceRequest _acceptedRequest() => ServiceRequest(
      id: 'r2',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: 'Plumbing',
      description: 'Fix leak',
      status: RequestStatus.accepted,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'Nairobi',
      createdAt: DateTime(2026, 9, 6),
    );

ServiceRequest _inProgressRequest() => ServiceRequest(
      id: 'r3',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: 'Plumbing',
      description: 'Fix leak',
      status: RequestStatus.inProgress,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'Nairobi',
      createdAt: DateTime(2026, 9, 6),
    );

ServiceRequest _completedRequest() => ServiceRequest(
      id: 'r4',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: 'Plumbing',
      description: 'Fix leak',
      status: RequestStatus.completed,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'Nairobi',
      createdAt: DateTime(2026, 9, 6),
    );

ServiceRequest _reviewedRequest() => ServiceRequest(
      id: 'r5',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: 'Plumbing',
      description: 'Fix leak',
      status: RequestStatus.reviewed,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'Nairobi',
      createdAt: DateTime(2026, 9, 6),
    );
