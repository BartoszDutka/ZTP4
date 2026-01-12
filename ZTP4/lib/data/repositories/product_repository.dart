import '../../core/error/exceptions.dart';
import '../../domain/models/product.dart';
import '../../domain/models/products_result.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';
import '../services/product_cache_service.dart';

/// Implementacja repozytorium produktów z obsługą cache offline
/// Warstwa danych - odpowiada za pobieranie danych z API i lokalnego cache
class ProductRepository implements IProductRepository {
  final ProductApiService apiService;
  final ProductCacheService cacheService;

  ProductRepository({
    required this.apiService,
    required this.cacheService,
  });

  /// Pobiera produkty - najpierw z API, przy braku sieci z cache
  Future<ProductsResult> getProductsWithSource() async {
    try {
      // Pobierz listę produktów (tylko id i name)
      final productList = await apiService.getProducts();
      
      // Pobierz szczegóły każdego produktu (cena, kategoria, itp.)
      final List<ProductModel> fullProducts = [];
      for (final product in productList) {
        try {
          final fullProduct = await apiService.getProductById(product.id);
          fullProducts.add(fullProduct);
        } catch (_) {
          // Jeśli nie uda się pobrać szczegółów, użyj podstawowych danych
          fullProducts.add(product);
        }
      }
      
      // Zapisz pełne dane do cache
      await cacheService.cacheProducts(fullProducts);
      
      return ProductsResult(
        products: fullProducts.map((model) => model.toEntity()).toList(),
        isFromCache: false,
      );
    } on NetworkException {
      // Brak sieci - pobierz z cache
      final cachedProducts = await cacheService.getCachedProducts();
      if (cachedProducts.isEmpty) {
        throw NetworkException('Brak połączenia z siecią i brak danych w cache.');
      }
      return ProductsResult(
        products: cachedProducts.map((model) => model.toEntity()).toList(),
        isFromCache: true,
      );
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    final result = await getProductsWithSource();
    return result.products;
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      // Próbuj pobrać z API
      final productModel = await apiService.getProductById(id);
      
      // Zapisz/aktualizuj pojedynczy produkt w cache (ma pełne dane)
      await cacheService.cacheProduct(productModel);
      
      return productModel.toEntity();
    } on NetworkException {
      // Brak sieci - pobierz z cache
      final cachedProduct = await cacheService.getCachedProductById(id);
      if (cachedProduct == null) {
        throw NetworkException('Brak połączenia z siecią i brak produktu w cache.');
      }
      return cachedProduct.toEntity();
    }
  }
}
