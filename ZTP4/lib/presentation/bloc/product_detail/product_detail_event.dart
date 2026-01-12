part of 'product_detail_bloc.dart';

/// Bazowa klasa dla eventów szczegółów produktu
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event do ładowania szczegółów produktu
class LoadProductDetail extends ProductDetailEvent {
  final String productId;

  const LoadProductDetail({required this.productId});

  @override
  List<Object?> get props => [productId];
}
