import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../core/error/exceptions.dart';
import '../models/cart_model.dart';

/// Serwis do komunikacji z API koszyka (Lab 3)
class CartApiService {
  final String baseUrl;
  final http.Client _client;

  CartApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Tworzy nowy koszyk
  Future<String> createCart(String userId) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl${ApiConfig.cartsEndpoint}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'userId': userId}),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);
      
      // API zwraca GUID jako string
      final cartId = json.decode(response.body);
      return cartId.toString();
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Pobiera koszyk po ID
  Future<CartModel> getCart(String cartId) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.cartsEndpoint}/$cartId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeout));

      _checkStatusCode(response);

      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      return CartModel.fromJson(jsonData);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Dodaje produkt do koszyka
  Future<void> addProductToCart(String cartId, String productId, int quantity) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl${ApiConfig.cartsEndpoint}/$cartId/items'),
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

  /// Usuwa produkt z koszyka
  Future<void> removeProductFromCart(String cartId, String productId, {int? quantity}) async {
    try {
      var uri = Uri.parse('$baseUrl${ApiConfig.cartsEndpoint}/$cartId/items/$productId');
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

  void _checkStatusCode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    switch (response.statusCode) {
      case 404:
        throw NotFoundException('Koszyk nie został znaleziony');
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
