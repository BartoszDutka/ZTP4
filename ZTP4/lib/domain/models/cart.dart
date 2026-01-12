import 'package:equatable/equatable.dart';

/// Model koszyka - warstwa domenowa
class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, items, totalAmount, createdAt, updatedAt];
}

/// Model pozycji w koszyku - warstwa domenowa
class CartItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice, totalPrice];
}
