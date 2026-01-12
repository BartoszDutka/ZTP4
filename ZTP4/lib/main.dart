import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/api_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/bff_api_service.dart';
import 'data/services/product_cache_service.dart';
import 'presentation/bloc/cart/cart_bloc.dart';
import 'presentation/bloc/product_list/product_list_bloc.dart';
import 'presentation/pages/product_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ustawienie stylu status bara
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection - BFF jako jedyny punkt komunikacji z backendem
    // Aplikacja NIE zna adresów Lab 1 i Lab 3 - komunikuje się tylko z BFF
    final bffService = BffApiService(baseUrl: ApiConfig.bffBaseUrl);
    final productCacheService = ProductCacheService();
    
    final productRepository = ProductRepository(
      bffService: bffService,
      cacheService: productCacheService,
    );
    
    final cartRepository = CartRepository(bffService: bffService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductListBloc(repository: productRepository)
            ..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => CartBloc(repository: cartRepository)
            ..add(const InitializeCart(userId: 'mobile-user')),
        ),
      ],
      child: MaterialApp(
        title: 'ZTP4 - Produkty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ProductListPage(),
      ),
    );
  }
}
