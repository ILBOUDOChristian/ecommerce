import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/catalog_filter.dart';
import '../../data/models/product.dart';
import 'products_provider.dart';

class CatalogFilterNotifier extends StateNotifier<CatalogFilter> {
  CatalogFilterNotifier() : super(const CatalogFilter());

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(String? category) {
    if (category == null || category == state.category) {
      state = state.copyWith(clearCategory: true);
      return;
    }
    state = state.copyWith(category: category);
  }

  void setSort(ProductSort sort) {
    state = state.copyWith(sort: sort);
  }

  void setInStockOnly(bool value) {
    state = state.copyWith(inStockOnly: value);
  }

  void reset() {
    state = const CatalogFilter();
  }
}

final catalogFilterProvider =
    StateNotifierProvider<CatalogFilterNotifier, CatalogFilter>((ref) {
  return CatalogFilterNotifier();
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final filter = ref.watch(catalogFilterProvider);
  return ref.watch(productsProvider).whenData((products) {
    var result = products.where((product) {
      final matchesQuery = filter.query.trim().isEmpty ||
          product.name.toLowerCase().contains(filter.query.toLowerCase()) ||
          product.description.toLowerCase().contains(filter.query.toLowerCase());
      final matchesCategory =
          filter.category == null || product.category == filter.category;
      final matchesStock = !filter.inStockOnly || product.inStock;
      return matchesQuery && matchesCategory && matchesStock;
    }).toList();

    switch (filter.sort) {
      case ProductSort.relevance:
        break;
      case ProductSort.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case ProductSort.ratingDesc:
        result.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return result;
  });
});
