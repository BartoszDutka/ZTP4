import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../domain/models/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

/// BLoC do zarządzania koszykiem
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  String? _cartId;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<InitializeCart>(_onInitializeCart);
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
  }

  String? get cartId => _cartId;

  Future<void> _onInitializeCart(
    InitializeCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      _cartId = await repository.createCart(event.userId);
      final cart = await repository.getCart(_cartId!);
      emit(CartLoaded(cart: cart));
    } on AppException catch (e) {
      emit(CartError(message: e.message));
    } catch (e) {
      emit(CartError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    if (_cartId == null) {
      emit(CartError(message: 'Koszyk nie został zainicjalizowany'));
      return;
    }

    emit(CartLoading());
    try {
      final cart = await repository.getCart(_cartId!);
      emit(CartLoaded(cart: cart));
    } on AppException catch (e) {
      emit(CartError(message: e.message));
    } catch (e) {
      emit(CartError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    if (_cartId == null) {
      emit(CartError(message: 'Koszyk nie został zainicjalizowany'));
      return;
    }

    final currentState = state;
    emit(CartOperationInProgress(
      cart: currentState is CartLoaded ? currentState.cart : null,
    ));

    try {
      await repository.addProductToCart(_cartId!, event.productId, event.quantity);
      final cart = await repository.getCart(_cartId!);
      emit(CartOperationSuccess(cart: cart, message: 'Dodano do koszyka'));
    } on AppException catch (e) {
      emit(CartError(message: e.message));
    } catch (e) {
      emit(CartError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (_cartId == null) {
      emit(CartError(message: 'Koszyk nie został zainicjalizowany'));
      return;
    }

    final currentState = state;
    emit(CartOperationInProgress(
      cart: currentState is CartLoaded ? currentState.cart : null,
    ));

    try {
      await repository.removeProductFromCart(_cartId!, event.productId);
      final cart = await repository.getCart(_cartId!);
      emit(CartOperationSuccess(cart: cart, message: 'Usunięto z koszyka'));
    } on AppException catch (e) {
      emit(CartError(message: e.message));
    } catch (e) {
      emit(CartError(message: 'Wystąpił nieoczekiwany błąd'));
    }
  }
}
