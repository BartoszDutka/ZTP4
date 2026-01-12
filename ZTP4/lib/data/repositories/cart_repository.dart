import '../../domain/models/cart.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../services/cart_api_service.dart';

/// Implementacja repozytorium koszyka
class CartRepository implements ICartRepository {
  final CartApiService apiService;

  CartRepository({required this.apiService});

  @override
  Future<String> createCart(String userId) async {
    return await apiService.createCart(userId);
  }

  @override
  Future<Cart> getCart(String cartId) async {
    final cartModel = await apiService.getCart(cartId);
    return cartModel.toEntity();
  }

  @override
  Future<void> addProductToCart(String cartId, String productId, int quantity) async {
    await apiService.addProductToCart(cartId, productId, quantity);
  }

  @override
  Future<void> removeProductFromCart(String cartId, String productId, {int? quantity}) async {
    await apiService.removeProductFromCart(cartId, productId, quantity: quantity);
  }
}
