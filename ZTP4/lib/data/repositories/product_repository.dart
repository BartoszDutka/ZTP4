import '../../domain/models/product.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../services/product_api_service.dart';

/// Implementacja repozytorium produktów
/// Warstwa danych - odpowiada za pobieranie danych z serwisu API
class ProductRepository implements IProductRepository {
  final ProductApiService apiService;

  ProductRepository({required this.apiService});

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await apiService.getProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final productModel = await apiService.getProductById(id);
    return productModel.toEntity();
  }
}
