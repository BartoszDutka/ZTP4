# ZTP4 - Aplikacja Mobilna Flutter

Aplikacja mobilna na ocenę 3.0 - integracja z API Lab 1 (Produkty).

## Funkcjonalności

- ✅ Wyświetlanie listy produktów (nazwa, cena)
- ✅ Szczegóły produktu (kategoria, pełna cena, ilość, data dodania)
- ✅ Obsługa stanów ładowania
- ✅ Obsługa błędów HTTP
- ✅ Pull-to-refresh do odświeżania listy

## Architektura

Aplikacja wykorzystuje wzorzec **BLoC** (Business Logic Component) z czystym podziałem architektonicznym:

```
lib/
├── core/
│   ├── config/         # Konfiguracja (API URL, timeouty)
│   └── error/          # Definicje wyjątków
├── data/
│   ├── models/         # Modele DTO (parsowanie JSON)
│   ├── repositories/   # Implementacje repozytoriów
│   └── services/       # Serwisy HTTP
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

## Konfiguracja

### Adres API
Zmień adres API w pliku `lib/core/config/api_config.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:5048';
```

- `10.0.2.2` - alias localhost dla emulatora Android
- Port `5048` - domyślny port API Lab 1
- Dla urządzenia fizycznego użyj IP komputera w sieci lokalnej

## Uruchomienie

1. Upewnij się, że API Lab 1 działa na porcie 5001:
   ```bash
   cd ZTP1/ZTP1
   docker-compose up -d
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

## Wymagania

- Flutter SDK ^3.5.0
- Android SDK (dla aplikacji Android)
- Działające API Lab 1
