import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import 'repository_providers.dart';

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).fetchProducts();
});

final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final products = await ref.watch(productsProvider.future);
  return products.firstWhere(
    (product) => product.id == id,
    orElse: () => throw StateError('Produit introuvable: $id'),
  );
});

final categoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  return ref.watch(productsProvider).whenData((products) {
    final categories = products.map((p) => p.category).toSet().toList()..sort();
    return categories;
  });
});
