abstract final class ApiFields {
  // General response fields.
  static const fields = 'fields';
  static const name = 'name';
  static const common = 'common';

  // Country identifiers.
  static const cca2 = 'cca2';
  static const alpha2Code = 'alpha2Code';

  // Country information.
  static const flags = 'flags';
  static const png = 'png';
  static const capital = 'capital';
  static const region = 'region';
  static const population = 'population';
  static const currencies = 'currencies';
  static const currencyCode = 'code';
  static const symbol = 'symbol';
  static const latlng = 'latlng';

  // Weather request and response fields.
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const current = 'current';
  static const temperature = 'temperature_2m';
  static const humidity = 'relative_humidity_2m';
  static const weatherCode = 'weather_code';
  static const windSpeed = 'wind_speed_10m';
  static const windSpeedUnit = 'wind_speed_unit';
  static const kmh = 'kmh';
  static const timezone = 'timezone';
  static const auto = 'auto';

  // Networking.
  static const acceptHeader = 'Accept';
  static const jsonContentType = 'application/json';
  static const https = 'https';
}

abstract final class FirebaseErrorCodes {
  static const invalidCredential = 'invalid-credential';

  static const invalidLoginCredentials = 'INVALID_LOGIN_CREDENTIALS';

  static const userNotFound = 'user-not-found';

  static const wrongPassword = 'wrong-password';

  static const invalidEmail = 'invalid-email';

  static const userDisabled = 'user-disabled';

  static const tooManyRequests = 'too-many-requests';

  static const networkRequestFailed = 'network-request-failed';

  static const operationNotAllowed = 'operation-not-allowed';

  static const userTokenExpired = 'user-token-expired';

  static const invalidUserToken = 'invalid-user-token';
}


