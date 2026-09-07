import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/profile_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Clé globale de l'icône panier (animation d'ajout).
final cartIconKeyProvider = Provider<GlobalKey>((ref) => GlobalKey());
