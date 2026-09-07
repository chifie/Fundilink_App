import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/service_request.dart';

void main() {
  group('ServiceRequest.formattedCost', () {
    test('formats a positive cost as a currency string', () {
      final request = ServiceRequest(
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
        estimatedCost: 800,
        createdAt: DateTime(2026, 9, 6),
      );
      expect(request.formattedCost, 'KES 800');
    });

    test('returns KES 0 when the cost is zero', () {
      final request = ServiceRequest(
        id: 'r2',
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
        estimatedCost: 0,
        createdAt: DateTime(2026, 9, 6),
      );
      expect(request.formattedCost, 'KES 0');
    });
  });
}
