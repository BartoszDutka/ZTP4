import '../../domain/models/cart.dart';
import '../../domain/repositories/i_cart_repository.dart';
import '../services/bff_api_service.dart';

/// Implementacja repozytorium koszyka
/// Komunikuje się TYLKO z BFF (wzorzec Backend For Frontend)
class CartRepository implements ICartRepository {
  final BffApiService bffService;

  CartRepository({required this.bffService});

  @override
  Future<String> createCart(String userId) async {
    return await bffService.createCart(userId);
  }

  @override
  Future<Cart> getCart(String cartId) async {
    final cartModel = await bffService.getCart(cartId);
    return cartModel.toEntity();
  }

  @override
  Future<void> addProductToCart(String cartId, String productId, int quantity) async {
    await bffService.addProductToCart(cartId, productId, quantity);
  }

  @override
  Future<void> removeProductFromCart(String cartId, String productId, {int? quantity}) async {
    await bffService.removeProductFromCart(cartId, productId, quantity: quantity);
  }
}

