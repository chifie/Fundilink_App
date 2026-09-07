import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/widgets/requests/request_filter_bar.dart';

ServiceRequest _request(String id, RequestStatus status) {
  return ServiceRequest(
    id: id,
    customerId: 'u1',
    customerName: 'Brian Kimani',
    fundiId: 'f1',
    fundiName: 'James Otieno',
    categoryId: 'cat_plumbing',
    categoryName: AppStrings.plumbing,
    description: 'Fix a leak',
    status: status,
    preferredDate: 'Sep 10',
    preferredTime: '2:00 PM',
    location: 'Nairobi',
    estimatedCost: 800,
    createdAt: DateTime(2026, 9, 5),
  );
}

List<ServiceRequest> _sample() {
  return [
    _request('r1', RequestStatus.pending),
    _request('r2', RequestStatus.accepted),
    _request('r3', RequestStatus.inProgress),
    _request('r4', RequestStatus.completed),
    _request('r5', RequestStatus.reviewed),
    _request('r6', RequestStatus.rejected),
  ];
}

void main() {
  group('RequestFilter.apply', () {
    test('all keeps every request', () {
      final requests = _sample();
      expect(RequestFilter.all.apply(requests), hasLength(6));
    });

    test('pending keeps only pending requests', () {
      final result = RequestFilter.pending.apply(_sample());
      expect(result.map((r) => r.id), ['r1']);
    });

    test('active keeps accepted and in-progress requests', () {
      final result = RequestFilter.active.apply(_sample());
      expect(result.map((r) => r.id), ['r2', 'r3']);
    });

    test('completed keeps completed and reviewed requests', () {
      final result = RequestFilter.completed.apply(_sample());
      expect(result.map((r) => r.id), ['r4', 'r5']);
    });

    test('rejected requests are excluded from every non-all bucket', () {
      final requests = _sample();
      for (final filter in RequestFilter.values) {
        if (filter == RequestFilter.all) continue;
        expect(
          filter.apply(requests).any((r) => r.status == RequestStatus.rejected),
          isFalse,
          reason: '$filter must exclude rejected requests',
        );
      }
    });
  });

  group('RequestFilter labels', () {
    test('each filter maps to its chip label', () {
      expect(RequestFilter.all.label, AppStrings.all);
      expect(RequestFilter.pending.label, AppStrings.pending);
      expect(RequestFilter.active.label, AppStrings.inProgress);
      expect(RequestFilter.completed.label, AppStrings.completed);
    });
  });

  group('RequestFilterBar', () {
    testWidgets('renders a chip for every bucket', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RequestFilterBar(
              current: RequestFilter.all,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.all), findsOneWidget);
      expect(find.text(AppStrings.pending), findsOneWidget);
      expect(find.text(AppStrings.inProgress), findsOneWidget);
      expect(find.text(AppStrings.completed), findsOneWidget);
    });

    testWidgets('tapping a chip reports the chosen bucket', (tester) async {
      RequestFilter? chosen;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RequestFilterBar(
              current: RequestFilter.all,
              onChanged: (filter) => chosen = filter,
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.completed));
      expect(chosen, RequestFilter.completed);
    });
  });
}
