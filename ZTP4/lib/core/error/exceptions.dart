/// Bazowa klasa dla błędów aplikacji
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Błąd połączenia z siecią
class NetworkException extends AppException {
  NetworkException([String message = 'Brak połączenia z siecią'])
      : super(message);
}

/// Błąd serwera (5xx)
class ServerException extends AppException {
  ServerException([String message = 'Błąd serwera', int? statusCode])
      : super(message, statusCode: statusCode);
}

/// Błąd klienta (4xx)
class ClientException extends AppException {
  ClientException([String message = 'Błąd żądania', int? statusCode])
      : super(message, statusCode: statusCode);
}

/// Błąd parsowania danych
class ParseException extends AppException {
  ParseException([String message = 'Błąd przetwarzania danych'])
      : super(message);
}

/// Zasób nie znaleziony (404)
class NotFoundException extends AppException {
  NotFoundException([String message = 'Nie znaleziono zasobu'])
      : super(message, statusCode: 404);
}
