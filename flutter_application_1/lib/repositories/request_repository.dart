
import 'package:uuid/uuid.dart';

import '../data/mock_data.dart';
import '../models/fundi_model.dart';
import '../models/service_request.dart';

/// Data source for service requests on both customer and fundi sides.
class RequestRepository {
  static const Duration _latency = Duration(milliseconds: 500);

  static const _uuid = Uuid();

  Future<List<ServiceRequest>> getCustomerRequests(String customerId) async {
    await Future<void>.delayed(_latency);
    final list = MockData.requestsForCustomer(customerId);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<List<ServiceRequest>> getFundiRequests(String fundiId) async {
    await Future<void>.delayed(_latency);
    final list = MockData.requestsForFundi(fundiId);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<ServiceRequest> createRequest({
    required String customerId,
    required String customerName,
    required Fundi fundi,
    required String categoryName,
    required String description,
    required String preferredDate,
    required String preferredTime,
    required String location,
    List<String> images = const [],
  }) async {
    await Future<void>.delayed(_latency);
    final request = ServiceRequest(
      id: _uuid.v4(),
      customerId: customerId,
      customerName: customerName,
      fundiId: fundi.id,
      fundiName: fundi.fullName,
      fundiAvatar: fundi.avatarUrl,
      categoryId: fundi.categoryId,
      categoryName: categoryName,
      description: description,
      status: RequestStatus.pending,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      location: location,
      images: images,
      estimatedCost: fundi.startingPrice,
      createdAt: DateTime.now(),
    );
    MockData.requests.add(request);
    return request;
  }

  Future<ServiceRequest> updateStatus(
    String requestId,
    RequestStatus status,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = MockData.requests.indexWhere((r) => r.id == requestId);
    if (index == -1) {
      throw StateError('Request $requestId not found');
    }
    final updated = MockData.requests[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    MockData.requests[index] = updated;
    return updated;
  }

  /// Total earnings: the sum of cost estimates for paid-out jobs.
  Future<double> totalEarnings(String fundiId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final jobs = MockData.requestsForFundi(fundiId).where((r) =>
        r.status == RequestStatus.completed ||
        r.status == RequestStatus.reviewed);
    return jobs.fold<double>(0, (sum, r) => sum + r.estimatedCost);
  }
}