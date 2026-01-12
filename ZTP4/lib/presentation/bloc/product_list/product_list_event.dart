part of 'product_list_bloc.dart';

/// Bazowa klasa dla eventów listy produktów
abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Event do ładowania listy produktów
class LoadProducts extends ProductListEvent {}

/// Event do odświeżania listy produktów
class RefreshProducts extends ProductListEvent {}
