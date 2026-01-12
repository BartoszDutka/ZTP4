/// Konfiguracja API
class ApiConfig {
  /// Bazowy URL do BFF (Backend For Frontend)
  /// 10.0.2.2 - alias localhost dla emulatora Android
  /// Aplikacja komunikuje się TYLKO z BFF, nie bezpośrednio z Lab 1/Lab 3
  static const String bffBaseUrl = 'http://10.0.2.2:5100';
  
  /// Bazowy URL do API Lab 1 (Produkty) - TYLKO dla trybu offline/fallback
  static const String baseUrl = 'http://10.0.2.2:5220';
  
  /// Bazowy URL do API Lab 3 (Koszyk) - TYLKO dla trybu offline/fallback
  static const String cartBaseUrl = 'http://10.0.2.2:5086';
  
  /// Endpoint BFF dla produktów
  static const String bffProductsEndpoint = '/api/v1/bff/products';
  
  /// Endpoint BFF dla koszyków
  static const String bffCartsEndpoint = '/api/v1/bff/carts';
  
  /// Endpoint dla produktów (legacy - direct)
  static const String productsEndpoint = '/api/v1/products';
  
  /// Endpoint dla koszyków (legacy - direct)
  static const String cartsEndpoint = '/api/v1/carts';
  
  /// Timeout dla połączeń HTTP (w sekundach)
  static const int connectionTimeout = 30;
}
