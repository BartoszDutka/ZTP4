import '../models/cart.dart';

/// Interfejs repozytorium koszyka
abstract class ICartRepository {
  /// Tworzy nowy koszyk
  Future<String> createCart(String userId);
  
  /// Pobiera koszyk po ID
  Future<Cart> getCart(String cartId);
  
  /// Dodaje produkt do koszyka
  Future<void> addProductToCart(String cartId, String productId, int quantity);
  
  /// Usuwa produkt z koszyka
  Future<void> removeProductFromCart(String cartId, String productId, {int? quantity});
}
