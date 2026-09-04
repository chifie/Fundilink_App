import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/availability.dart';
import '../models/fundi_model.dart';
import '../models/portfolio_item.dart';
import '../models/service_category.dart';
import '../repositories/fundi_repository.dart';

/// Manages service categories and fundi listings.
class FundiProvider extends ChangeNotifier {
  FundiProvider({FundiRepository? repository})
      : _repository = repository ?? FundiRepository();

  final FundiRepository _repository;

  List<ServiceCategory> _categories = [];
  List<Fundi> _fundis = [];
  bool _loading = false;
  String? _error;

  List<ServiceCategory> get categories => _categories;
  List<Fundi> get fundis => _fundis;
  bool get isLoading => _loading;
  String? get error => _error;

  /// The four highest-rated fundis, used on the customer home screen.
  List<Fundi> get recommended {
    final list = List<Fundi>.of(_fundis);
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(4).toList();
  }

  /// Fundis closest to the customer, used on the customer home screen.
  List<Fundi> get nearby {
    final list = List<Fundi>.of(_fundis);
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list.take(4).toList();
  }

  Fundi? fundiById(String id) => MockData.fundiById(id);

  Future<void> loadCategories() async {
    _categories = await _repository.getCategories();
    notifyListeners();
  }

  Future<void> loadFundis({
    String? categoryId,
    String? query,
    String? location,
    String? sortBy,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _fundis = await _repository.getFundis(
        categoryId: categoryId,
        query: query,
        location: location,
        sortBy: sortBy,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query, {String? sortBy}) =>
      loadFundis(query: query, sortBy: sortBy);

  Future<void> filterByCategory(String? categoryId, {String? sortBy}) =>
      loadFundis(categoryId: categoryId, sortBy: sortBy);

  Future<void> updateProfile(Fundi updated) async {
    await _repository.updateFundiProfile(updated);
    await loadFundis();
  }

  Future<List<PortfolioItem>> portfolioFor(String fundiId) =>
      _repository.getPortfolio(fundiId);

  Future<Availability> availabilityFor(String fundiId) =>
      _repository.getAvailability(fundiId);
}