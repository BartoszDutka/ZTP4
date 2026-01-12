/// Konfiguracja API
class ApiConfig {
  /// Bazowy URL do API Lab 1
  /// Zmień na odpowiedni adres jeśli API działa na innym hoście/porcie
  /// 10.0.2.2 - alias localhost dla emulatora Android
  /// Port 5048 - domyślny port API Lab 1
  static const String baseUrl = 'http://10.0.2.2:5048';
  
  /// Endpoint dla produktów
  static const String productsEndpoint = '/api/v1/products';
  
  /// Timeout dla połączeń HTTP (w sekundach)
  static const int connectionTimeout = 30;
}
