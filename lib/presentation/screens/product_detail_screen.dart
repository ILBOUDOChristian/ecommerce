import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../providers/repository_providers.dart';
import '../widgets/async_value_widget.dart';
import '../widgets/cart_fly_animation.dart';
import '../widgets/common.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final productId = widget.productId;
    final productAsync = ref.watch(productByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(productId),
            icon: Icon(
              ref.watch(isFavoriteProvider(productId))
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: ref.watch(isFavoriteProvider(productId))
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: productAsync,
        onRetry: () => ref.invalidate(productByIdProvider(productId)),
        data: (product) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    AspectRatio(
                      aspectRatio: 1.15,
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: KeyedSubtree(
                            key: _imageKey,
                            child: ProductImage(url: product.imageUrl),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      product.category.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber),
                        Text(
                          '${product.rating}  (${product.reviewCount} avis)',
                        ),
                        const Spacer(),
                        PriceText(
                          product.price,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(product.description),
                    if (!product.inStock) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Ce produit est actuellement en rupture de stock.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                    ),
                    onPressed: product.inStock
                        ? () {
                            ref.read(cartProvider.notifier).add(product);
                            playAddToCartAnimation(
                              context: context,
                              imageKey: _imageKey,
                              cartIconKey: ref.read(cartIconKeyProvider),
                              imageUrl: product.imageUrl,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${product.name} ajouté au panier'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: Text(
                      product.inStock ? 'Ajouter au panier' : 'Indisponible',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
