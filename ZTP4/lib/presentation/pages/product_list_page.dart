import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/product_list_item.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Strona z listą produktów
/// Wyświetla listę produktów pobranych z API Lab 1
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocConsumer<ProductListBloc, ProductListState>(
                listener: (context, state) {
                  if (state is ProductListLoaded && state.isOffline) {
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
                              child: const Icon(Icons.cloud_off, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Tryb offline',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Dane z pamięci lokalnej',
                                    style: TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppTheme.warningColor,
                        duration: const Duration(seconds: 3),
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return const LoadingView(message: 'Ładowanie produktów...');
                  }

                  if (state is ProductListError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () {
                        context.read<ProductListBloc>().add(LoadProducts());
                      },
                    );
                  }

                  if (state is ProductListLoaded) {
                    return _buildProductList(context, state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produkty',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 4),
              BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoaded) {
                    return Text(
                      '${state.products.length} dostępnych',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          _buildCartButton(context),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        if (state is CartLoaded) {
          itemCount = state.cart.items.length;
        } else if (state is CartOperationSuccess) {
          itemCount = state.cart.items.length;
        }
        
        return GestureDetector(
          onTap: () => _navigateToCart(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                if (itemCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList(BuildContext context, ProductListLoaded state) {
    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppTheme.primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Brak produktów',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Lista produktów jest pusta',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Baner trybu offline
        if (state.isOffline)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.warningColor.withOpacity(0.1),
                  AppTheme.warningColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.warningColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.cloud_off, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tryb offline',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.warningColor,
                        ),
                      ),
                      Text(
                        'Wyświetlane dane z pamięci lokalnej',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductListBloc>().add(RefreshProducts());
            },
            color: AppTheme.primaryColor,
            backgroundColor: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: ProductListItem(
                    product: product,
                    onTap: () => _navigateToDetail(context, product.id),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Nawiguje do strony szczegółów produktu
  void _navigateToDetail(BuildContext context, String productId) {
    final repository = context.read<ProductListBloc>().repository;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (navContext) => ProductDetailBloc(repository: repository)
            ..add(LoadProductDetail(productId: productId)),
          child: const ProductDetailPage(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Nawiguje do strony koszyka
  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(
          value: context.read<CartBloc>(),
          child: const CartPage(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
