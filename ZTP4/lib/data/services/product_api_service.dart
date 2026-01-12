import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../core/error/exceptions.dart';
import '../models/api_response_model.dart';
import '../models/product_model.dart';

/// Serwis do komunikacji z API produktów (Lab 1)
/// Obsługuje wszystkie żądania HTTP
class ProductApiService {
  final String baseUrl;
  final http.Client _client;

  ProductApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Pobiera listę wszystkich produktów z API
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.productsEndpoint}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleListResponse(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią. Sprawdź połączenie internetowe.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Pobiera szczegóły produktu po ID
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl${ApiConfig.productsEndpoint}/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleSingleResponse(response);
    } on SocketException {
      throw NetworkException('Brak połączenia z siecią. Sprawdź połączenie internetowe.');
    } on http.ClientException {
      throw NetworkException('Błąd połączenia z serwerem.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Nieoczekiwany błąd: ${e.toString()}');
    }
  }

  /// Przetwarza odpowiedź z listą produktów
  List<ProductModel> _handleListResponse(http.Response response) {
    _checkStatusCode(response);

    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final apiResponse = ApiResponseModel.fromJson(
        jsonData,
        (data) => (data as List)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (!apiResponse.success) {
        throw ServerException(
          apiResponse.message ?? 'Operacja nie powiodła się',
          apiResponse.errorCode,
        );
      }

      return apiResponse.data ?? [];
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParseException('Błąd przetwarzania odpowiedzi serwera');
    }
  }

  /// Przetwarza odpowiedź z pojedynczym produktem
  ProductModel _handleSingleResponse(http.Response response) {
    _checkStatusCode(response);

    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final apiResponse = ApiResponseModel.fromJson(
        jsonData,
        (data) => ProductModel.fromJson(data as Map<String, dynamic>),
      );

      if (!apiResponse.success) {
        throw ServerException(
          apiResponse.message ?? 'Operacja nie powiodła się',
          apiResponse.errorCode,
        );
      }

      if (apiResponse.data == null) {
        throw NotFoundException('Produkt nie został znaleziony');
      }

      return apiResponse.data!;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParseException('Błąd przetwarzania odpowiedzi serwera');
    }
  }

  /// Sprawdza kod statusu HTTP i rzuca odpowiedni wyjątek
  void _checkStatusCode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    switch (response.statusCode) {
      case 404:
        throw NotFoundException('Zasób nie został znaleziony');
      case 400:
        throw ClientException('Nieprawidłowe żądanie', 400);
      case 401:
        throw ClientException('Brak autoryzacji', 401);
      case 403:
        throw ClientException('Brak dostępu', 403);
      case 500:
      case 502:
      case 503:
        throw ServerException('Błąd serwera. Spróbuj ponownie później.', response.statusCode);
      default:
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw ClientException('Błąd żądania', response.statusCode);
        } else {
          throw ServerException('Błąd serwera', response.statusCode);
        }
    }
  }
}
