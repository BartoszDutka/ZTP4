import '../../domain/models/cart.dart';

/// Model koszyka dla warstwy danych (DTO)
class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: (json['items'] as List?)
              ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Cart toEntity() {
    return Cart(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Model pozycji koszyka dla warstwy danych (DTO)
class CartItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CartItem toEntity() {
    return CartItem(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
    );
  }
}
