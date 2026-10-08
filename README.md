# Country Weather App 🌍

A Flutter application to explore countries, check current weather, view maps, and save favorite countries.

## Features

- Email and password login.
- Search countries by name.
- Country flags, capitals, regions, population, and currencies.
- Add and remove favorite countries.
- Current temperature, humidity, wind speed, and weather conditions.
- Map showing the selected country’s location.
- Pull-to-refresh with shimmer loading.

## Requirements

- Flutter SDK.
- Android Studio or VS Code with Flutter tooling.
- Android emulator or physical Android device.
- Internet connection.

## Clone the Repository

```bash
git clone https://github.com/Sumit0922/country_weather_app.git
cd country_weather_app
```

## Install Dependencies

```bash
flutter pub get
```

## Run the Application

Start an Android emulator or connect an Android device, then run:

```bash
flutter run --dart-define=COUNTRIES_BASE_URL=https://countries.dev
```

## Test Login

Use these demo credentials to sign in:

| Field | Value |
|---|---|
| Email | `test@gmail.com` |
| Password | `12345678` |

## How to Use

1. Sign in using the test credentials.
2. Browse countries or search by name.
3. Tap a country to view its details, weather, and map.
4. Tap the heart icon to add or remove a favorite.
5. Open **Favorites** to view saved countries.
6. Pull down on the country list to refresh.

Favorites are stored locally on the device.

## Build an Android APK

```bash
flutter build apk --release --dart-define=COUNTRIES_BASE_URL=https://countries.dev
```

The APK will be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Data Sources

- [Countries API](https://countries.dev/)
- [Open-Meteo](https://open-meteo.com/)
- [OpenStreetMap](https://www.openstreetmap.org/copyright) — © OpenStreetMap contributors
