import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/data/mock_data.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/providers/request_provider.dart';

void main() {
  group('RequestProvider loading', () {
    test('loadCustomerRequests returns the customer seed requests', () async {
      final provider = RequestProvider();
      await provider.loadCustomerRequests('u1');

      expect(provider.customerRequests, isNotEmpty);
      expect(provider.error, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('loadFundiRequests drives the dashboard counts', () async {
      final provider = RequestProvider();
      await provider.loadFundiRequests('f1');

      // James Otieno (f1) has two pending, two active and one completed job
      // among his seed requests.
      expect(provider.pendingCount, 2);
      expect(provider.activeCount, 2);
      expect(provider.completedCount, 1);
    });
  });

  group('RequestProvider updates', () {
    test('createRequest inserts a pending request for the customer', () async {
      final provider = RequestProvider();
      final fundi = MockData.fundiById('f1')!;

      await provider.createRequest(
        customerId: 'u-tester',
        customerName: 'Tester',
        fundi: fundi,
        categoryName: fundi.categoryName,
        description: 'Provider test request',
        preferredDate: 'Sep 20, 2026',
        preferredTime: '10:00 AM',
        location: 'Nairobi',
      );

      expect(provider.customerRequests, isNotEmpty);
      final created = provider.customerRequests.first;
      expect(created.status, RequestStatus.pending);
      expect(created.fundiId, 'f1');
      expect(created.estimatedCost, fundi.startingPrice);
      expect(created.description, 'Provider test request');
    });

    test('updateStatus is reflected by byId in both lists', () async {
      final provider = RequestProvider();
      await provider.loadFundiRequests('f1');
      await provider.loadCustomerRequests('u1');

      final before = provider.byId('r7');
      expect(before?.status, RequestStatus.pending);

      await provider.updateStatus('r7', RequestStatus.inProgress);

      expect(provider.byId('r7')?.status, RequestStatus.inProgress);
      final fundiList = provider.fundiRequests.firstWhere((r) => r.id == 'r7');
      expect(fundiList.status, RequestStatus.inProgress);
    });
  });

  group('RequestProvider earnings', () {
    test('totalEarnings aggregates paid-out jobs for a fundi', () async {
      final provider = RequestProvider();
      final earnings = await provider.totalEarnings('f1');
      expect(earnings, 2200.0);
    });
  });
}
