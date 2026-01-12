import 'package:equatable/equatable.dart';

/// Model produktu - warstwa domenowa
/// Reprezentuje produkt pobrany z API Lab 1
class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, category, price, quantity, createdAt];
}
