import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

/// Manages the signed-in user and session lifecycle.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  bool _loading = false;
  String? _error;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _loading;
  User? get user => _user;
  UserRole? get role => _user?.role;
  String? get error => _error;

  /// Restores the persisted session on app launch.
  Future<void> restoreSession() async {
    _status = AuthStatus.unknown;
    notifyListeners();
    final user = await _repository.restoreSession();
    if (user != null) {
      _user = user;
      _status = AuthStatus.authenticated;
    } else {
      _user = null;
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repository.login(email: email, password: password);
      await _repository.saveSession(user);
      _user = user;
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      await _repository.saveSession(user);
      _user = user;
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.forgotPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}