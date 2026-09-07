import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/catalog_filter.dart';
import '../providers/catalog_filter_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/async_value_widget.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    final products = ref.watch(filteredProductsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoply'),
        actions: [
          PopupMenuButton<ProductSort>(
            tooltip: 'Trier',
            initialValue: filter.sort,
            onSelected: (sort) =>
                ref.read(catalogFilterProvider.notifier).setSort(sort),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ProductSort.relevance,
                child: Text('Pertinence'),
              ),
              PopupMenuItem(
                value: ProductSort.priceAsc,
                child: Text('Prix croissant'),
              ),
              PopupMenuItem(
                value: ProductSort.priceDesc,
                child: Text('Prix décroissant'),
              ),
              PopupMenuItem(
                value: ProductSort.nameAsc,
                child: Text('Nom A-Z'),
              ),
              PopupMenuItem(
                value: ProductSort.ratingDesc,
                child: Text('Mieux notés'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: ref.read(catalogFilterProvider.notifier).setQuery,
              decoration: const InputDecoration(
                hintText: 'Rechercher un produit…',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          AsyncValueWidget(
            value: categories,
            onRetry: () => ref.invalidate(productsProvider),
            data: (items) {
              return SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Tous'),
                        selected: filter.category == null,
                        onSelected: (_) => ref
                            .read(catalogFilterProvider.notifier)
                            .setCategory(null),
                      ),
                    ),
                    ...items.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: filter.category == category,
                          onSelected: (_) => ref
                              .read(catalogFilterProvider.notifier)
                              .setCategory(category),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: FilterChip(
                        label: const Text('En stock'),
                        selected: filter.inStockOnly,
                        onSelected: (value) => ref
                            .read(catalogFilterProvider.notifier)
                            .setInStockOnly(value),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncValueWidget(
              value: products,
              onRetry: () => ref.invalidate(productsProvider),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Aucun produit ne correspond aux filtres.'),
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
                  itemBuilder: (context, index) {
                    return ProductCard(product: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
