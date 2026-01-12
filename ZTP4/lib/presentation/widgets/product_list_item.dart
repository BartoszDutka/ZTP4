import 'package:flutter/material.dart';
import '../../domain/models/product.dart';

/// Widget elementu listy produktów
/// Wyświetla podstawowe informacje: nazwa i cena
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductListItem({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${product.price.toStringAsFixed(2)} PLN',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
