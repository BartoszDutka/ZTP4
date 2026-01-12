import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../core/error/exceptions.dart';
import '../models/api_response_model.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';

/// Serwis BFF - jedyny punkt komunikacji z backendem
/// Implementuje wzorzec Backend For Frontend (BFF)
/// Aplikacja nie komunikuje się bezpośrednio z Lab 1 i Lab 3
class BffApiService {
  final String baseUrl;
  final http.Client _client;

  BffApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  // ============================================
  // PRODUKTY - Agregacja z Lab 1 przez BFF
  // ============================================

  /// Pobiera listę wszystkich produktów z BFF
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.bffProductsEndpoint}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleProductListResponse(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią. Sprawdź połączenie internetowe.');
    } on TimeoutException {
      throw NetworkException('Przekroczono limit czasu połączenia.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Pobiera szczegóły produktu po ID z BFF
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.bffProductsEndpoint}/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleProductResponse(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią. Sprawdź połączenie internetowe.');
    } on TimeoutException {
      throw NetworkException('Przekroczono limit czasu połączenia.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  // ============================================
  // KOSZYK - Agregacja z Lab 3 przez BFF
  // ============================================

  /// Tworzy nowy koszyk przez BFF
  Future<String> createCart(String userId) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl${ApiConfig.bffCartsEndpoint}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'userId': userId}),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);
      
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return jsonData['data'].toString();
      }
      throw ServerException('Nie udało się utworzyć koszyka');
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Pobiera koszyk po ID przez BFF
  Future<CartModel> getCart(String cartId) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.bffCartsEndpoint}/$cartId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);

      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      if (jsonData['success'] == true && jsonData['data'] != null) {
        return CartModel.fromJson(jsonData['data'] as Map<String, dynamic>);
      }
      throw NotFoundException('Koszyk nie został znaleziony');
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Dodaje produkt do koszyka przez BFF
  Future<void> addProductToCart(String cartId, String productId, int quantity) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl${ApiConfig.bffCartsEndpoint}/$cartId/items'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'productId': productId,
              'quantity': quantity,
            }),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Usuwa produkt z koszyka przez BFF
  Future<void> removeProductFromCart(String cartId, String productId, {int? quantity}) async {
    try {
      var uri = Uri.parse('$baseUrl${ApiConfig.bffCartsEndpoint}/$cartId/items/$productId');
      if (quantity != null) {
        uri = uri.replace(queryParameters: {'quantity': quantity.toString()});
      }

      final response = await _client
          .delete(
            uri,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  // ============================================
  // POMOCNICZE
  // ============================================

  /// Przetwarza odpowiedź z listą produktów z BFF
  List<ProductModel> _handleProductListResponse(http.Response response) {
    _checkStatusCode(response);

    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      
      if (jsonData['success'] != true) {
        throw ServerException(
          jsonData['message'] ?? 'Operacja nie powiodła się',
          null,
        );
      }

      final data = jsonData['data'] as Map<String, dynamic>?;
      if (data == null) return [];

      final products = data['products'] as List?;
      if (products == null) return [];

      return products
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParseException('Błąd przetwarzania odpowiedzi serwera');
    }
  }

  /// Przetwarza odpowiedź z pojedynczym produktem z BFF
  ProductModel _handleProductResponse(http.Response response) {
    _checkStatusCode(response);

    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      if (jsonData['success'] != true) {
        throw ServerException(
          jsonData['message'] ?? 'Operacja nie powiodła się',
          null,
        );
      }

      final data = jsonData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw NotFoundException('Produkt nie został znaleziony');
      }

      return ProductModel.fromJson(data);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParseException('Błąd przetwarzania odpowiedzi serwera');
    }
  }

  void _checkStatusCode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    switch (response.statusCode) {
      case 404:
        throw NotFoundException('Zasób nie został znaleziony');
      case 400:
        throw ClientException('Nieprawidłowe żądanie', 400);
      case 409:
        throw ClientException('Konflikt - spróbuj ponownie', 409);
      case 500:
      case 502:
      case 503:
        throw ServerException('Błąd serwera. Spróbuj ponownie później.', response.statusCode);
      default:
        throw ServerException('Błąd serwera', response.statusCode);
    }
  }
}
