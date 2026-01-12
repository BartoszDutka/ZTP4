import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/api_config.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/product_api_service.dart';
import 'presentation/bloc/product_list/product_list_bloc.dart';
import 'presentation/pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection - tworzenie zależności
    final apiService = ProductApiService(baseUrl: ApiConfig.baseUrl);
    final repository = ProductRepository(apiService: apiService);

    return MaterialApp(
      title: 'ZTP4 - Produkty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ProductListBloc(repository: repository)
          ..add(LoadProducts()),
        child: const ProductListPage(),
      ),
    );
  }
}
