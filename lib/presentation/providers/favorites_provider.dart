import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import '../../data/repositories/favorites_repository.dart';
import 'products_provider.dart';
import 'repository_providers.dart';

class FavoritesNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final FavoritesRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.loadIds);
  }

  Future<void> toggle(String productId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final next = {...current};
    if (next.contains(productId)) {
      next.remove(productId);
    } else {
      next.add(productId);
    }

    state = AsyncValue.data(next);
    try {
      await _repository.saveIds(next);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> retry() => _load();
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<Set<String>>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});

final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(favoritesProvider).maybeWhen(
        data: (ids) => ids.contains(productId),
        orElse: () => false,
      );
});

final favoriteProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final products = ref.watch(productsProvider);

  return favorites.when(
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
    data: (ids) {
      return products.when(
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
        data: (list) => AsyncValue.data(
          list.where((product) => ids.contains(product.id)).toList(),
        ),
      );
    },
  );
});
