enum ProductSort {
  relevance,
  priceAsc,
  priceDesc,
  nameAsc,
  ratingDesc,
}

class CatalogFilter {
  const CatalogFilter({
    this.query = '',
    this.category,
    this.sort = ProductSort.relevance,
    this.inStockOnly = false,
  });

  final String query;
  final String? category;
  final ProductSort sort;
  final bool inStockOnly;

  CatalogFilter copyWith({
    String? query,
    String? category,
    ProductSort? sort,
    bool? inStockOnly,
    bool clearCategory = false,
  }) {
    return CatalogFilter(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      sort: sort ?? this.sort,
      inStockOnly: inStockOnly ?? this.inStockOnly,
    );
  }
}
