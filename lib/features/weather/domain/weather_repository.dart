import '../../countries/domain/country.dart';
import 'weather.dart';

abstract interface class WeatherRepository {
  Future<Weather> getCurrentWeather(Coordinates coordinates);
}
