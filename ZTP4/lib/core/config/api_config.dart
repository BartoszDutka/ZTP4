/// Konfiguracja API
class ApiConfig {
  /// Bazowy URL do API Lab 1 (Produkty)
  /// 10.0.2.2 - alias localhost dla emulatora Android
  static const String baseUrl = 'http://10.0.2.2:5220';
  
  /// Bazowy URL do API Lab 3 (Koszyk)
  static const String cartBaseUrl = 'http://10.0.2.2:5086';
  
  /// Endpoint dla produktów
  static const String productsEndpoint = '/api/v1/products';
  
  /// Endpoint dla koszyków
  static const String cartsEndpoint = '/api/v1/carts';
  
  /// Timeout dla połączeń HTTP (w sekundach)
  static const int connectionTimeout = 30;
}
