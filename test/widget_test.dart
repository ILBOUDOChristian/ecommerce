import 'package:flutter_test/flutter_test.dart';
import 'package:shoply/data/models/product.dart';
import 'package:shoply/presentation/providers/cart_provider.dart';

const _product = Product(
  id: 'p01',
  name: 'Casque test',
  description: 'desc',
  price: 10,
  category: 'Audio',
  imageUrl: 'https://example.com/img.webp',
  rating: 4.5,
  reviewCount: 10,
  inStock: true,
);

void main() {
  test('le panier ajoute, incrémente et supprime', () {
    final cart = CartNotifier();

    cart.add(_product);
    expect(cart.state, hasLength(1));
    expect(cart.state.first.quantity, 1);

    cart.add(_product);
    expect(cart.state.first.quantity, 2);

    cart.decrement('p01');
    expect(cart.state.first.quantity, 1);

    cart.remove('p01');
    expect(cart.state, isEmpty);
  });
}
