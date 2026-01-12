part of 'cart_bloc.dart';

/// Bazowa klasa stanów koszyka
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy
class CartInitial extends CartState {}

/// Stan ładowania
class CartLoading extends CartState {}

/// Stan załadowanego koszyka
class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({required this.cart});

  @override
  List<Object?> get props => [cart];
}

/// Stan podczas operacji (dodawanie/usuwanie)
class CartOperationInProgress extends CartState {
  final Cart? cart;

  const CartOperationInProgress({this.cart});

  @override
  List<Object?> get props => [cart];
}

/// Stan po udanej operacji
class CartOperationSuccess extends CartState {
  final Cart cart;
  final String message;

  const CartOperationSuccess({required this.cart, required this.message});

  @override
  List<Object?> get props => [cart, message];
}

/// Stan błędu
class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
