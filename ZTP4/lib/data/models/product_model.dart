import '../../domain/models/product.dart';

/// Model produktu dla warstwy danych (DTO)
/// Obsługuje serializację/deserializację JSON z API
class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.createdAt,
  });

  /// Tworzy ProductModel z mapy JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Konwertuje ProductModel na encję domenową Product
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      quantity: quantity,
      createdAt: createdAt,
    );
  }
}
