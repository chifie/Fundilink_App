import '../../core/constants/api_constants.dart';
import 'api_client.dart';

/// Typed access to the FundiLink REST API.
///
/// Each method maps to a documented endpoint in [ApiConstants]. Feature
/// repositories call these methods once the backend is live; until then they
/// serve sample data from the mock layer.
class ApiService {
  ApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.post(ApiConstants.login, body: {
      'email': email,
      'password': password,
    });
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final data = await _client.post(ApiConstants.register, body: {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    });
    return data as Map<String, dynamic>;
  }

  Future<void> forgotPassword(String email) async {
    await _client.post(ApiConstants.forgotPassword, body: {'email': email});
  }

  // ---------------------------------------------------------------------------
  // Fundis & categories
  // ---------------------------------------------------------------------------
  Future<List<dynamic>> getCategories() async =>
      await _client.get(ApiConstants.categories) as List<dynamic>;

  Future<List<dynamic>> getFundis({
    String? search,
    String? category,
    String? location,
    String? sort,
  }) async {
    return await _client.get(ApiConstants.fundis, query: {
      if (search != null) ApiConstants.searchParam: search,
      if (category != null) ApiConstants.categoryParam: category,
      if (location != null) ApiConstants.locationParam: location,
      if (sort != null) ApiConstants.sortParam: sort,
    }) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getFundi(String id) async =>
      await _client.get('${ApiConstants.fundis}/$id') as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // Service requests
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> createRequest(Map<String, dynamic> body) async =>
      await _client.post(ApiConstants.serviceRequests, body: body)
          as Map<String, dynamic>;

  Future<List<dynamic>> getCustomerRequests(String customerId) async =>
      await _client.get('${ApiConstants.serviceRequests}/customer/$customerId')
          as List<dynamic>;

  Future<List<dynamic>> getFundiRequests(String fundiId) async =>
      await _client.get('${ApiConstants.serviceRequests}/fundi/$fundiId')
          as List<dynamic>;

  Future<Map<String, dynamic>> updateRequestStatus(
    String requestId,
    String status,
  ) async {
    return await _client.put(
      '${ApiConstants.updateRequestStatus}/$requestId',
      body: {'status': status},
    ) as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Chat
  // ---------------------------------------------------------------------------
  Future<List<dynamic>> getConversations(String userId) async =>
      await _client.get('${ApiConstants.conversations}/$userId')
          as List<dynamic>;

  Future<List<dynamic>> getMessages(String conversationId) async =>
      await _client.get('${ApiConstants.messages}/$conversationId')
          as List<dynamic>;

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async =>
      await _client.post(ApiConstants.messages, body: body)
          as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // Reviews, notifications, earnings
  // ---------------------------------------------------------------------------
  Future<List<dynamic>> getReviews(String fundiId) async =>
      await _client.get('${ApiConstants.fundiReviews}/$fundiId')
          as List<dynamic>;

  Future<Map<String, dynamic>> addReview(Map<String, dynamic> body) async =>
      await _client.post(ApiConstants.reviews, body: body)
          as Map<String, dynamic>;

  Future<List<dynamic>> getNotifications() async =>
      await _client.get(ApiConstants.notifications) as List<dynamic>;

  Future<void> markNotificationsRead() async {
    await _client.put(ApiConstants.markNotificationsRead);
  }

  Future<Map<String, dynamic>> getEarnings(String fundiId) async =>
      await _client.get('${ApiConstants.earnings}/$fundiId')
          as Map<String, dynamic>;
}