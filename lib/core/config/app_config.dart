abstract final class AppConfig {
  static const countriesBaseUrl = String.fromEnvironment(
    'COUNTRIES_BASE_URL',
    defaultValue: 'https://countries.dev',
  );

  static const weatherBaseUrl = String.fromEnvironment(
    'WEATHER_BASE_URL',
    defaultValue: 'https://api.open-meteo.com',
  );

  static const countriesPath = '/countries';
  static const weatherPath = '/v1/forecast';

  static const countryFields =
      'name,alpha2Code,flags,capital,region,population,currencies,latlng';

  static const currentWeatherFields =
      'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m';

  static const tilesUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const osmCopyrightUrl = 'https://www.openstreetmap.org/copyright';

  static const weatherAttributionUrl = 'https://open-meteo.com/';

  static const packageName = 'com.example.country_weather_explorer';

  static const storageBox = 'country_explorer';
  static const countryCacheKey = 'countries_v1';
  static const favoritesPrefix = 'favorites_v1_';

  static const timeout = Duration(seconds: 20);

  static const animationDuration = Duration(milliseconds: 220);

  static const metricAnimationDuration = Duration(milliseconds: 650);

  static const contentWidth = 1000.0;
  static const formWidth = 440.0;
}
