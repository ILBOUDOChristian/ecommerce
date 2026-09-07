import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/async_value_widget.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: AsyncValueWidget(
        value: favorites,
        onRetry: () {
          ref.invalidate(productsProvider);
          ref.read(favoritesProvider.notifier).retry();
        },
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Aucun favori pour le moment.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                ProductCard(product: items[index]),
          );
        },
      ),
    );
  }
}
