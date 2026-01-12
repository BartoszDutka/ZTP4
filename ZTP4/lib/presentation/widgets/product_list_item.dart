import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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
    final categoryColor = AppTheme.getCategoryColor(product.category);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ikona kategorii
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppTheme.getCategoryGradient(product.category),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    _getCategoryIcon(product.category),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Informacje o produkcie
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.quantity} szt.',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Cena i strzałka
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PLN',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'elektronika':
        return Icons.devices_outlined;
      case 'książki':
        return Icons.menu_book_outlined;
      case 'odzież':
        return Icons.checkroom_outlined;
      case 'sport':
        return Icons.fitness_center_outlined;
      case 'dom':
        return Icons.home_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
