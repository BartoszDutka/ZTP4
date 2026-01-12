part of 'cart_bloc.dart';

/// Bazowa klasa eventów koszyka
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Inicjalizacja koszyka (tworzenie nowego)
class InitializeCart extends CartEvent {
  final String userId;

  const InitializeCart({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Ładowanie koszyka
class LoadCart extends CartEvent {}

/// Dodanie produktu do koszyka
class AddToCart extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCart({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

/// Usunięcie produktu z koszyka
class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}
