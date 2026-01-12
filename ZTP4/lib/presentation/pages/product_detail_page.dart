import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        title: const Text('Szczegóły produktu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const LoadingView(message: 'Ładowanie szczegółów...');
          }

          if (state is ProductDetailError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                Navigator.pop(context);
              },
              retryButtonText: 'Wróć',
            );
          }

          if (state is ProductDetailLoaded) {
            return ProductDetailView(product: state.product);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
