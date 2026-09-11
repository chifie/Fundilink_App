import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../models/user_model.dart';

/// Auth data source.
///
/// Persists the signed-in user id locally and, once the backend is live,
/// will delegate to `ApiService`. Until then it works against the mock
/// account store.
class AuthRepository {
  static const String _sessionKey = 'fundilink_session_user_id';

  static const Duration _latency = Duration(milliseconds: 600);

  Future<void> _simulateNetwork() => Future<void>.delayed(_latency);

  Future<User> login({required String email, required String password}) async {
    await _simulateNetwork();
    // Mock auth: any account is accepted; a matching demo account restores
    // its role, otherwise a customer is created on the fly.
    if (email == mockFundiUser.email) return mockFundiUser;
    return mockCustomer;
  }

  Future<User> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    await _simulateNetwork();
    // Mock registration: prefer the demo account matching the chosen role so
    // the fundi workspace has real data to explore.
    if (role == UserRole.fundi) return mockFundiUser;
    return mockCustomer;
  }

  Future<void> forgotPassword(String email) async {
    await _simulateNetwork();
  }

  /// Restores the last signed-in user, if any.
  Future<User?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_sessionKey);
    if (userId == null) return null;
    await _simulateNetwork();
    if (userId == mockFundiUser.id) return mockFundiUser;
    if (userId == mockCustomer.id) return mockCustomer;
    return null;
  }

  Future<void> saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, user.id);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
