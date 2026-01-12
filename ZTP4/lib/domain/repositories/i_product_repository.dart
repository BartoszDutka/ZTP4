import '../models/product.dart';

/// Interfejs repozytorium produktów
/// Definiuje kontrakt dla warstwy danych
abstract class IProductRepository {
  /// Pobiera listę wszystkich produktów
  Future<List<Product>> getProducts();
  
  /// Pobiera szczegóły produktu po ID
  Future<Product> getProductById(String id);
}
