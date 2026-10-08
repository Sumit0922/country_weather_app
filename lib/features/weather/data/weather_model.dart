import '../../../core/constants/api_fields.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/weather.dart';

abstract final class WeatherModel {
  static Weather fromJson(Object? response) {
    if (response is! Map) {
      throw const AppException(AppStrings.invalidResponse);
    }

    final current = response[ApiFields.current];

    if (current is! Map) {
      throw const AppException(AppStrings.invalidResponse);
    }

    final temperature = _number(current[ApiFields.temperature]);
    final humidity = _number(current[ApiFields.humidity]);
    final windSpeed = _number(current[ApiFields.windSpeed]);
    final code = _number(current[ApiFields.weatherCode]);

    if (temperature == null ||
        humidity == null ||
        windSpeed == null ||
        code == null ||
        humidity < 0 ||
        humidity > 100 ||
        windSpeed < 0 ||
        code < 0 ||
        code != code.truncateToDouble()) {
      throw const AppException(AppStrings.invalidResponse);
    }

    return Weather(
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
      code: code.toInt(),
    );
  }

  static double? _number(Object? value) {
    if (value is! num) return null;
    final number = value.toDouble();
    return number.isFinite ? number : null;
  }
}
