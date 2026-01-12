part of 'product_detail_bloc.dart';

/// Bazowa klasa dla stanów szczegółów produktu
abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy
class ProductDetailInitial extends ProductDetailState {}

/// Stan ładowania
class ProductDetailLoading extends ProductDetailState {}

/// Stan sukcesu - szczegóły produktu załadowane
class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Stan błędu
class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
