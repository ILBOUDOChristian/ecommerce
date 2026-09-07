import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void add(Product product, {int quantity = 1}) {
    if (!product.inStock) return;
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      state = [...state, CartItem(product: product, quantity: quantity)];
      return;
    }
    final current = state[index];
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index)
          current.copyWith(quantity: current.quantity + quantity)
        else
          state[i],
    ];
  }

  void increment(String productId) {
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrement(String productId) {
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: item.quantity - 1)
        else
          item,
    ].where((item) => item.quantity > 0).toList();
  }

  void remove(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void clear() {
    state = const [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity);
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.lineTotal);
});

final cartContainsProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(cartProvider).any((item) => item.product.id == productId);
});
