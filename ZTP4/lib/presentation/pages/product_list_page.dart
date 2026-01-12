import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/product_repository.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/product_list_item.dart';
import 'product_detail_page.dart';

/// Strona z listą produktów
/// Wyświetla listę produktów pobranych z API Lab 1
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkty'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
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
            if (state.products.isEmpty) {
              return const Center(
                child: Text(
                  'Brak produktów',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductListBloc>().add(RefreshProducts());
              },
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductListItem(
                    product: product,
                    onTap: () => _navigateToDetail(context, product.id),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Nawiguje do strony szczegółów produktu
  void _navigateToDetail(BuildContext context, String productId) {
    final repository = context.read<ProductListBloc>().repository;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProductDetailBloc(repository: repository)
            ..add(LoadProductDetail(productId: productId)),
          child: const ProductDetailPage(),
        ),
      ),
    );
  }
}
