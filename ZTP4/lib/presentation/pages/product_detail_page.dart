import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/product_detail_view.dart';

/// Strona szczegółów produktu
/// Wyświetla pełne informacje o produkcie
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const LoadingView(message: 'Ładowanie szczegółów...');
          }

          if (state is ProductDetailError) {
            return SafeArea(
              child: Column(
                children: [
                  _buildBackButton(context),
                  Expanded(
                    child: ErrorView(
                      message: state.message,
                      onRetry: () {
                        Navigator.pop(context);
                      },
                      retryButtonText: 'Wróć',
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProductDetailLoaded) {
            return ProductDetailView(
              product: state.product,
              onAddToCart: () => _addToCart(context, state.product.id),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: AppTheme.cardShadow,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, String productId) {
    final cartBloc = context.read<CartBloc>();
    cartBloc.add(AddToCart(productId: productId));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Dodano do koszyka',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Produkt został dodany',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
