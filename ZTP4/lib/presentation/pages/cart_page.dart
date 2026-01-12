import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/cart/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

/// Strona koszyka
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartOperationSuccess) {
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
                            Expanded(
                              child: Text(
                                state.message,
                                style: const TextStyle(fontWeight: FontWeight.w500),
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
                },
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const LoadingView(message: 'Ładowanie koszyka...');
                  }

                  if (state is CartError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () {
                        context.read<CartBloc>().add(LoadCart());
                      },
                    );
                  }

                  if (state is CartOperationInProgress) {
                    return const LoadingView(message: 'Przetwarzanie...');
                  }

                  final cart = state is CartLoaded
                      ? state.cart
                      : state is CartOperationSuccess
                          ? state.cart
                          : null;

                  if (cart == null) {
                    return const Center(child: Text('Koszyk nie został załadowany'));
                  }

                  if (cart.items.isEmpty) {
                    return _buildEmptyCart(context);
                  }

                  return _buildCartContent(context, cart);
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
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 8),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Koszyk',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    int itemCount = 0;
                    if (state is CartLoaded) {
                      itemCount = state.cart.items.length;
                    } else if (state is CartOperationSuccess) {
                      itemCount = state.cart.items.length;
                    }
                    return Text(
                      '$itemCount ${_getItemsText(itemCount)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Koszyk jest pusty',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Dodaj produkty do koszyka,\naby kontynuować zakupy',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Przeglądaj produkty'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, dynamic cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(20 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: CartItemWidget(
                  item: item,
                  onRemove: () {
                    context.read<CartBloc>().add(
                          RemoveFromCart(productId: item.productId),
                        );
                  },
                ),
              );
            },
          ),
        ),
        // Total section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suma',
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
                            cart.totalAmount.toStringAsFixed(2),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              'PLN',
                              style: TextStyle(
                                color: AppTheme.textMuted,
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
                    decoration: BoxDecoration(
                      boxShadow: AppTheme.elevatedShadow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementacja checkout
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Funkcja zamówienia wkrótce!'),
                            backgroundColor: AppTheme.infoColor,
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Zamów',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getItemsText(int count) {
    if (count == 1) return 'produkt';
    if (count >= 2 && count <= 4) return 'produkty';
    return 'produktów';
  }
}
