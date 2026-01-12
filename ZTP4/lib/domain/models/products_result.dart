import 'product.dart';

/// Wynik pobierania produktów z informacją o źródle danych
class ProductsResult {
  final List<Product> products;
  final bool isFromCache;

  const ProductsResult({
    required this.products,
    this.isFromCache = false,
  });
}
