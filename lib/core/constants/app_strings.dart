abstract final class AppStrings {
  // Application.
  static const appName = 'Country Explorer';

  static const appDescription = 'Discover places. Check the weather.';

  static const preparingExplorer = 'Your world, ready to explore.';

  // Authentication.
  static const welcome = 'Welcome back';

  static const loginSubtitle = 'Sign in to explore countries around the world.';

  static const email = 'Email address';

  static const emailHint = 'you@example.com';

  static const password = 'Password';

  static const signIn = 'Sign in';

  static const signOut = 'Sign out';

  static const signingIn = 'Signing in';

  static const showPassword = 'Show password';

  static const hidePassword = 'Hide password';

  static const testAccountHint =
      'Use the email and password created in Firebase Authentication.';

  static const loginSuccess = 'Signed in successfully';

  static const logoutSuccess = 'Signed out successfully';

  static const logoutTitle = 'Sign out?';

  static const logoutMessage =
      'Are you sure you want to sign out of Country Explorer?';

  static const cancel = 'Cancel';

  // Validation.
  static const requiredEmail = 'Please enter your email address.';

  static const invalidEmail = 'Please enter a valid email address.';

  static const requiredPassword = 'Please enter your password.';

  // Countries and search.
  static const explore = 'Explore countries';

  static const exploreSubtitle = 'Your next discovery starts with a country.';

  static const searchHint = 'Search countries by name';

  static const searchLabel = 'Find your next destination';

  static const clearSearch = 'Clear search';

  static const allCountries = 'All countries';

  static const favorites = 'Favorites';

  static const addFavorite = 'Add to favorites';

  static const removeFavorite = 'Remove from favorites';

  static const savedFavorites = 'Saved on this device';

  static const noCountries = 'No countries available';

  static const noCountriesMessage =
      'The service returned an empty country list.';

  static const noResults = 'No matching countries';

  static const noResultsMessage =
      'Try another country name or clear your search.';

  static const noFavorites = 'No favorites yet';

  static const noFavoritesMessage =
      'Tap the heart beside a country to save it here.';

  static const cachedCountries =
      'Showing saved countries. Refresh when you are online.';

  static const countryLoadError = 'Unable to load countries';

  static const countryServiceError =
      'The country service could not complete the request. Please retry.';

  // Country details.
  static const capital = 'Capital';

  static const region = 'Region';

  static const population = 'Population';

  static const currency = 'Currency';

  static const coordinates = 'Coordinates';

  static const latitude = 'Latitude';

  static const longitude = 'Longitude';

  static const countryOverview = 'Country overview';

  static const countryInformation = 'Explore this country';

  // Map.
  static const location = 'Location';

  static const locationDescription =
      'The marker and weather use the country coordinates supplied by the API.';

  static const noCoordinates = 'Location unavailable';

  static const noCoordinatesMessage =
      'This country has no valid coordinates for weather or a map.';

  static const osmCredit = '© OpenStreetMap contributors';

  static const openMapCredit = 'Open map attribution';

  static const mapFailed =
      'Some map tiles could not load. Check your connection and retry.';

  static const linkFailed = 'Unable to open the attribution link.';

  // Weather.
  static const currentWeather = 'Current weather';

  static const weatherDescription =
      'Conditions at the selected country coordinates.';

  static const weatherAtLocation = 'Weather at country coordinates';

  static const temperature = 'Temperature';

  static const humidity = 'Humidity';

  static const windSpeed = 'Wind speed';

  static const weatherCredit = 'Weather data by Open-Meteo';

  static const weatherLoadError = 'Weather is unavailable';

  static const feelsFresh = 'A little insight before your next journey.';

  // Weather conditions.
  static const clearSky = 'Clear sky';

  static const partlyCloudy = 'Partly cloudy';

  static const overcast = 'Overcast';

  static const fog = 'Fog';

  static const drizzle = 'Drizzle';

  static const freezingDrizzle = 'Freezing drizzle';

  static const rain = 'Rain';

  static const freezingRain = 'Freezing rain';

  static const snow = 'Snow';

  static const snowGrains = 'Snow grains';

  static const rainShowers = 'Rain showers';

  static const snowShowers = 'Snow showers';

  static const thunderstorm = 'Thunderstorm';

  static const unknownWeather = 'Unknown condition';

  // Common states and actions.
  static const loading = 'Loading…';

  static const loadingCountries = 'Discovering countries…';

  static const loadingWeather = 'Checking the weather…';

  static const retry = 'Retry';

  static const refresh = 'Refresh';

  static const unavailable = 'Not available';

  static const errorTitle = 'Something went wrong';

  // Network and storage errors.
  static const networkError =
      'Unable to connect. Check your internet connection and try again.';

  static const timeoutError = 'The request took too long. Please try again.';

  static const serverError =
      'The service is currently unavailable. Please try again.';

  static const requestError = 'The request could not be completed.';

  static const invalidResponse = 'The service returned an invalid response.';

  static const cancelled = 'The request was cancelled.';

  static const unexpectedError = 'Something went wrong. Please try again.';

  static const storageError = 'Unable to save your changes on this device.';

  static const startupError =
      'Unable to start the app. Check your configuration and connection.';

  // Firebase errors.
  static const invalidCredentials = 'The email or password is incorrect.';

  static const disabledAccount = 'This account has been disabled.';

  static const tooManyRequests =
      'Too many attempts. Please wait and try again.';

  static const authUnavailable =
      'Email/password sign-in is unavailable. Check Firebase configuration.';

  static const authExpired = 'Your session has expired. Sign in again.';

  static const androidOnly =
      'Firebase configuration is currently provided for Android only.';

  // Formatting.
  static const empty = '';

  static const separator = ' • ';

  static const listSeparator = ', ';

  static const decimalPattern = '#,##0';

  static const locale = 'en';

  static String countryCount(int count) => '$count countries';

  static String resultsCount(int count) => '$count results';

  static String temperatureValue(double value) =>
      '${value.toStringAsFixed(1)} °C';

  static String humidityValue(double value) => '${value.toStringAsFixed(0)}%';

  static String windValue(double value) => '${value.toStringAsFixed(1)} km/h';

  static String coordinateValue(double value) => value.toStringAsFixed(4);

  static String coordinatesValue(double lat, double lng) =>
      '${coordinateValue(lat)}, ${coordinateValue(lng)}';

  static String currencyValue(String name, String code, String? symbol) =>
      '$name ($code)${symbol == null ? empty : ' · $symbol'}';

  static String flagLabel(String country) => '$country flag';

  // Debug diagnostics.
  static String apiRequest(String method, Uri uri) => '$method $uri';

  static String apiFailure(Uri uri, int? status, String type) =>
      'API failure: $uri | status: $status | type: $type';

  static String serviceStatus(int status) =>
      'The service returned HTTP $status. Please try again.';

  static String countriesLoaded(int count) =>
      'Countries loaded successfully: $count';

  static String countryParsingFailed(Object error) =>
      'Country response could not be parsed: $error';
}
