# ZTP4 - Aplikacja Mobilna Flutter

Aplikacja mobilna na ocenę **5.0** - pełna integracja z API Lab 1 (Produkty), Lab 3 (Koszyk) oraz wzorzec BFF.

## Funkcjonalności

### Ocena 3.0 ✅
- ✅ Wyświetlanie listy produktów (nazwa, cena)
- ✅ Szczegóły produktu (kategoria, pełna cena, ilość, data dodania)
- ✅ Obsługa stanów ładowania
- ✅ Obsługa błędów HTTP
- ✅ Pull-to-refresh do odświeżania listy
- ✅ Wzorzec BLoC (czysty podział architektoniczny)

### Ocena 4.0 ✅
- ✅ Integracja z serwisem Lab 3 (Koszyk)
- ✅ Dodawanie produktów do koszyka
- ✅ Widok koszyka z listą produktów
- ✅ Usuwanie produktów z koszyka

### Ocena 4.5 ✅
- ✅ Tryb offline (read-only)
- ✅ Lokalny cache produktów (SQLite)
- ✅ Przeglądanie produktów bez dostępu do sieci

### Ocena 5.0 ✅
- ✅ **Wzorzec Backend For Frontend (BFF)**
- ✅ Aplikacja komunikuje się TYLKO z BFF (nie zna adresów Lab 1 i Lab 3)
- ✅ BFF agreguje dane z Lab 1 i Lab 3
- ✅ Minimalizacja liczby żądań HTTP z urządzenia mobilnego

## Architektura

### Wzorzec BFF (Backend For Frontend)

```
┌─────────────────┐
│   Flutter App   │
│    (Mobile)     │
└────────┬────────┘
         │ tylko BFF
         ▼
┌─────────────────┐
│      BFF        │
│  (port 5100)    │
└───┬─────────┬───┘
    │         │
    ▼         ▼
┌───────┐ ┌───────┐
│ Lab 1 │ │ Lab 3 │
│ :5220 │ │ :5086 │
└───────┘ └───────┘
```

Aplikacja wykorzystuje wzorzec **BLoC** (Business Logic Component) z czystym podziałem architektonicznym:

```
lib/
├── core/
│   ├── config/         # Konfiguracja (BFF URL, timeouty)
│   └── error/          # Definicje wyjątków
├── data/
│   ├── models/         # Modele DTO (parsowanie JSON)
│   ├── repositories/   # Implementacje repozytoriów (używają BFF)
│   └── services/       # Serwisy HTTP (BFF API Service)
├── domain/
│   ├── models/         # Encje domenowe
│   └── repositories/   # Interfejsy repozytoriów
└── presentation/
    ├── bloc/           # BLoC (eventy, stany, logika)
    ├── pages/          # Strony/ekrany
    └── widgets/        # Komponenty UI
```

### Zasady architektoniczne:
- **BLoC** nie posiada bezpośrednich referencji do elementów UI
- **Logika biznesowa** znajduje się w BLoC i serwisach, nie w widokach
- **Komunikacja HTTP** jest asynchroniczna (nie blokuje UI)
- **Separacja warstw**: data, domain, presentation
- **BFF Pattern**: aplikacja nie komunikuje się bezpośrednio z mikroserwisami

## Konfiguracja

### Adres BFF
Zmień adres BFF w pliku `lib/core/config/api_config.dart`:

```dart
static const String bffBaseUrl = 'http://10.0.2.2:5100';
```

- `10.0.2.2` - alias localhost dla emulatora Android
- Port `5100` - port BFF
- Dla urządzenia fizycznego użyj IP komputera w sieci lokalnej

## Uruchomienie

1. Uruchom wszystkie serwisy (BFF, Lab 1, Lab 3) z katalogu głównego:
   ```bash
   docker-compose up -d --build
   ```

2. Zainstaluj zależności Flutter:
   ```bash
   cd ZTP4
   flutter pub get
   ```

3. Uruchom aplikację:
   ```bash
   flutter run
   ```

## Serwisy

| Serwis | Port | Opis |
|--------|------|------|
| BFF | 5100 | Backend For Frontend - jedyny punkt wejścia dla aplikacji |
| Lab 1 | 5220 | API produktów |
| Lab 3 | 5086 | API koszyka |
| MongoDB | 27017 | Baza danych |

## API BFF

BFF udostępnia następujące endpointy:

### Produkty
- `GET /api/v1/bff/products` - lista wszystkich produktów
- `GET /api/v1/bff/products/{id}` - szczegóły produktu

### Koszyk
- `POST /api/v1/bff/carts` - utworzenie koszyka
- `GET /api/v1/bff/carts/{cartId}` - pobranie koszyka
- `POST /api/v1/bff/carts/{cartId}/items` - dodanie produktu
- `DELETE /api/v1/bff/carts/{cartId}/items/{productId}` - usunięcie produktu

## Wymagania

- Flutter SDK ^3.5.0
- Android SDK (dla aplikacji Android)
- Docker i Docker Compose

