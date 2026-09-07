import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  ProductRepository({this.assetPath = 'assets/data/products.json'});

  final String assetPath;

  Future<List<Product>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Product> fetchById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere(
      (product) => product.id == id,
      orElse: () => throw StateError('Produit introuvable: $id'),
    );
  }
}
