import 'package:flutter/material.dart';
import '../../domain/models/product.dart';

/// Widget wyświetlający szczegóły produktu
class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nagłówek z nazwą produktu
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryChip(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cena
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cena',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${product.price.toStringAsFixed(2)} PLN',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Szczegóły
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Szczegóły',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  _buildDetailRow(context, 'Kategoria', product.category),
                  _buildDetailRow(context, 'Ilość na stanie', '${product.quantity} szt.'),
                  _buildDetailRow(
                    context,
                    'Data dodania',
                    _formatDate(product.createdAt),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Buduje chip z kategorią produktu
  Widget _buildCategoryChip(BuildContext context) {
    return Chip(
      label: Text(
        product.category,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: _getCategoryColor(product.category),
    );
  }

  /// Buduje wiersz ze szczegółami
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  /// Formatuje datę
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Zwraca kolor dla kategorii
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'elektronika':
        return Colors.blue;
      case 'książki':
        return Colors.orange;
      case 'odzież':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
