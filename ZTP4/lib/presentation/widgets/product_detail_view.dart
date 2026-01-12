import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/product.dart';

/// Widget wyświetlający szczegóły produktu
class ProductDetailView extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;

  const ProductDetailView({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(product.category);
    
    return Stack(
      children: [
        // Gradient header
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: AppTheme.getCategoryGradient(product.category),
          ),
        ),
        // Content
        SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(product.category),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Icon centered
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(product.category),
                  size: 64,
                  color: Colors.white,
                ),
              ),
              // Main content card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Price card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                categoryColor.withOpacity(0.1),
                                categoryColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cena',
                                    style: TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        product.price.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: categoryColor,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          'PLN',
                                          style: TextStyle(
                                            color: categoryColor.withOpacity(0.7),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: categoryColor,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                ),
                                child: Icon(
                                  Icons.sell_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Details section
                        Text(
                          'Szczegóły',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildDetailCard(
                          context,
                          icon: Icons.category_outlined,
                          label: 'Kategoria',
                          value: product.category,
                          color: categoryColor,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailCard(
                          context,
                          icon: Icons.inventory_2_outlined,
                          label: 'Na stanie',
                          value: '${product.quantity} szt.',
                          color: product.quantity > 0 ? AppTheme.successColor : AppTheme.errorColor,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailCard(
                          context,
                          icon: Icons.calendar_today_outlined,
                          label: 'Data dodania',
                          value: _formatDate(product.createdAt),
                          color: AppTheme.infoColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom button
        Positioned(
          left: 24,
          right: 24,
          bottom: 32,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: AppTheme.elevatedShadow,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_shopping_cart, size: 22),
                  const SizedBox(width: 12),
                  const Text(
                    'Dodaj do koszyka',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
