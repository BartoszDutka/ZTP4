import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/cart.dart';

/// Widget elementu koszyka
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ikona produktu
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
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
                    item.productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${item.unitPrice.toStringAsFixed(2)} PLN',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.textMuted.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              '×${item.quantity}',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Cena i przycisk usuwania
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.totalPrice.toStringAsFixed(2),
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
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
