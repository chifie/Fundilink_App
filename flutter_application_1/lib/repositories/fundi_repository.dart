import '../data/mock_data.dart';
import '../models/fundi_model.dart';
import '../models/service_category.dart';

/// Data source for service categories and fundi listings.
class FundiRepository {
  static const Duration _latency = Duration(milliseconds: 500);

  Future<List<ServiceCategory>> getCategories() async {
    await Future<void>.delayed(_latency);
    return List.of(MockData.categories);
  }

  Future<List<Fundi>> getFundis({
    String? categoryId,
    String? query,
    String? location,
    String? sortBy,
  }) async {
    await Future<void>.delayed(_latency);
    var results = List<Fundi>.of(MockData.fundis);

    if (categoryId != null && categoryId.isNotEmpty) {
      results = results.where((f) => f.categoryId == categoryId).toList();
    }

    final search = query?.trim().toLowerCase() ?? '';
    if (search.isNotEmpty) {
      results = results.where((f) {
        final haystack = '${f.fullName} ${f.categoryName} ${f.location} '
            '${f.serviceTags.join(' ')}'.toLowerCase();
        return haystack.contains(search);
      }).toList();
    }

    if (location != null && location.isNotEmpty) {
      final area = location.trim().toLowerCase();
      results = results.where((f) => f.city.toLowerCase().contains(area)).toList();
    }

    switch (sortBy) {
      case 'rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price':
        results.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
        break;
      case 'distance':
        results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      default:
        results.sort((a, b) => a.rating.compareTo(b.rating));
    }

    return results;
  }

  Future<Fundi> getFundi(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockData.fundiById(id)!;
  }

  /// Applies an edited fundi profile back to the local store.
  Future<void> updateFundiProfile(Fundi updated) async {
    await Future<void>.delayed(_latency);
    final index = MockData.fundis.indexWhere((f) => f.id == updated.id);
    if (index != -1) {
      MockData.fundis[index] = updated;
    }
  }
}