import 'package:flutter/foundation.dart';

import '../models/fundi_model.dart';
import '../models/service_request.dart';
import '../repositories/request_repository.dart';

/// Manages service requests for the signed-in customer or fundi.
class RequestProvider extends ChangeNotifier {
  RequestProvider({RequestRepository? repository})
    : _repository = repository ?? RequestRepository();

  final RequestRepository _repository;

  List<ServiceRequest> _customerRequests = [];
  List<ServiceRequest> _fundiRequests = [];
  bool _loading = false;
  String? _error;

  List<ServiceRequest> get customerRequests => _customerRequests;
  List<ServiceRequest> get fundiRequests => _fundiRequests;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> loadCustomerRequests(String customerId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _customerRequests = await _repository.getCustomerRequests(customerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadFundiRequests(String fundiId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _fundiRequests = await _repository.getFundiRequests(fundiId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ServiceRequest? byId(String id) {
    for (final r in [..._customerRequests, ..._fundiRequests]) {
      if (r.id == id) return r;
    }
    return null;
  }

  Future<void> createRequest({
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
    final request = await _repository.createRequest(
      customerId: customerId,
      customerName: customerName,
      fundi: fundi,
      categoryName: categoryName,
      description: description,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      location: location,
      images: images,
    );
    _customerRequests.insert(0, request);
    notifyListeners();
  }

  Future<void> updateStatus(String requestId, RequestStatus status) async {
    final updated = await _repository.updateStatus(requestId, status);
    _replaceInBoth(updated);
    notifyListeners();
  }

  Future<double> totalEarnings(String fundiId) =>
      _repository.totalEarnings(fundiId);

  void _replaceInBoth(ServiceRequest updated) {
    _customerRequests = _customerRequests
        .map((r) => r.id == updated.id ? updated : r)
        .toList();
    _fundiRequests = _fundiRequests
        .map((r) => r.id == updated.id ? updated : r)
        .toList();
  }

  // Convenience counts used by the fundi dashboard.
  int get pendingCount =>
      _fundiRequests.where((r) => r.status == RequestStatus.pending).length;
  int get activeCount => _fundiRequests
      .where(
        (r) =>
            r.status == RequestStatus.accepted ||
            r.status == RequestStatus.inProgress,
      )
      .length;
  int get completedCount => _fundiRequests
      .where(
        (r) =>
            r.status == RequestStatus.completed ||
            r.status == RequestStatus.reviewed,
      )
      .length;
}
