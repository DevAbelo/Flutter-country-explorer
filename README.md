# 🌍 Flutter Country Explorer

## Student Information
- **Name:** [Abel]
- **Student ID:** [ATE/0668/15]
- **Course:** Mobile Application Development
- **Assignment:** Unit 4 — Networking, REST APIs & Data Handling in Flutter
- **Instructor:** Abel Tadesse

---

## Track
**Track A — Country Explorer App**
Using the [RestCountries API](https://restcountries.com/v3.1) (free, no API key required)

---

## App Description
Country Explorer is a Flutter mobile application that fetches and displays real-time data about every country in the world using the RestCountries public REST API. Users can browse all 250+ countries, search by name, and view detailed information about any country including its flag, capital, population, currencies, languages, area, and timezones.

---

## Screens
| Screen | Description |
|--------|-------------|
| **Home Screen** | Scrollable list of all 250+ countries with flag emoji, name, region, and population |
| **Search Screen** | Search any country by name with live results from the API |
| **Detail Screen** | Full country details — flag, official name, capital, population, area, currencies, languages, timezones |

---

## How to Run the App Locally

### Prerequisites
- Flutter SDK (3.x or later) installed
- Dart SDK included with Flutter
- Android Studio or VS Code with Flutter extension
- A connected Android device or emulator

### Steps

**1. Clone the repository:**
```bash
git clone https://github.com/YOUR_USERNAME/flutter-country-explorer.git
cd flutter-country-explorer
```

**2. Install dependencies:**
```bash
flutter pub get
```

**3. Run the app:**
```bash
# On Android device/emulator
flutter run -d android

# On Windows desktop
flutter run -d windows

# On Chrome (requires CORS flag)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

**4. Build APK:**
```bash
flutter build apk --release
```
The APK will be at `build/app/outputs/flutter-apk/app-release.apk`

> ⚠️ No `.env` file is required for this project. The RestCountries API is completely free and requires no API key.

---

## API Endpoints Used

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/v3.1/all?fields=name,flag,region,population,cca3` | Fetch all countries for home screen |
| `GET` | `/v3.1/name/{name}` | Search countries by name |
| `GET` | `/v3.1/alpha/{code}` | Fetch single country by ISO alpha-3 code for detail screen |

**Base URL:** `https://restcountries.com`

---

## Project Structure
```
lib/
├── main.dart                        # App entry point
├── models/
│   └── country.dart                 # Country model with fromJson, toJson, copyWith
├── services/
│   ├── country_api_service.dart     # All HTTP logic — fetchAllCountries, searchByName, fetchByCode
│   └── api_exception.dart           # Custom exception for non-200 HTTP responses
└── screens/
    ├── home_screen.dart             # Screen 1 — full country list
    ├── search_screen.dart           # Screen 2 — search by name
    └── detail_screen.dart           # Screen 3 — country details
```

---

## Technical Features Implemented

- ✅ `http` package used for all HTTP requests (not Dio)
- ✅ `Uri.https()` used for all URL construction — no string concatenation
- ✅ 10-second timeout on every request
- ✅ Custom `ApiException` class for non-200 HTTP responses
- ✅ `Country` model with `fromJson`, `toJson`, and `copyWith`
- ✅ All model fields are `final` and explicitly typed
- ✅ Dedicated `CountryApiService` class — all HTTP logic in one place
- ✅ No HTTP imports in any screen or widget file
- ✅ `FutureBuilder` handles all 4 states: loading, error, no-data, data
- ✅ Retry button on every error screen
- ✅ `mounted` check after every `await` in StatefulWidgets
- ✅ All 5 error types handled: `SocketException`, `TimeoutException`, `ApiException`, `FormatException`, generic `Exception`

---

## Error Handling

| Error Type | Cause | Message Displayed |
|------------|-------|-------------------|
| `SocketException` | No internet connection | "No internet connection" |
| `TimeoutException` | Request took longer than 10 seconds | "Request timed out. Please try again." |
| `ApiException` | Server returned non-200 status code | "Server error {statusCode}: {message}" |
| `FormatException` | Malformed or unexpected JSON | "Unexpected data format received" |
| `Exception` | Any other unexpected error | "An unexpected error occurred: {message}" |

---

## Known Limitations & Bugs

1. **Flag display on some devices** — The app uses flag emoji characters (`🇪🇹`) which may not render correctly on older Android versions (below Android 7.0). A future improvement would be to use the `flags` image URL from the API instead.
2. **No pagination** — The home screen loads all 250+ countries at once. On very slow connections this may take a few seconds. Pagination was not implemented in this version.
3. **No local caching** — Every app launch fetches fresh data from the API. There is no offline cache, so the app requires an active internet connection to display any data.
4. **Web CORS limitation** — Running on Chrome requires the `--disable-web-security` flag due to CORS restrictions on the RestCountries API. The app is intended for Android deployment.
5. **Search is exact-match dependent** — The RestCountries `/name/` endpoint returns a 404 if no country matches, which is shown as an error rather than an empty results message.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
```

---

## References
- [RestCountries API Documentation](https://restcountries.com)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Flutter FutureBuilder Documentation](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
- [Dart async/await Documentation](https://dart.dev/codelabs/async-await)

---

## Academic Integrity
This project was developed individually as part of the Mobile Application Development course at Addis Ababa University. All code was written by the student. AI tools were used as a learning aid; all code is understood and can be explained by the author.
