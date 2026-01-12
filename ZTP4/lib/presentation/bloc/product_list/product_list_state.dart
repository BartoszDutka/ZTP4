part of 'product_list_bloc.dart';

/// Bazowa klasa dla stanów listy produktów
abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy
class ProductListInitial extends ProductListState {}

/// Stan ładowania
class ProductListLoading extends ProductListState {}

/// Stan sukcesu - lista produktów załadowana
class ProductListLoaded extends ProductListState {
  final List<Product> products;

  const ProductListLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

/// Stan błędu
class ProductListError extends ProductListState {
  final String message;

  const ProductListError({required this.message});

  @override
  List<Object?> get props => [message];
}
