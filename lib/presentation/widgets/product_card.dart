import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/repository_providers.dart';
import '../screens/product_detail_screen.dart';
import 'cart_fly_animation.dart';
import 'common.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final favorite = ref.watch(isFavoriteProvider(product.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: KeyedSubtree(
                        key: _imageKey,
                        child: ProductImage(url: product.imageUrl),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(product.id),
                        icon: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                    ),
                  ),
                  if (!product.inStock)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Chip(
                        label: const Text('Rupture'),
                        visualDensity: VisualDensity.compact,
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      PriceText(product.price),
                      const Spacer(),
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        onPressed: product.inStock
                            ? () {
                                ref.read(cartProvider.notifier).add(product);
                                playAddToCartAnimation(
                                  context: context,
                                  imageKey: _imageKey,
                                  cartIconKey: ref.read(cartIconKeyProvider),
                                  imageUrl: product.imageUrl,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
