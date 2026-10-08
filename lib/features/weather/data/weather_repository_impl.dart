import '../../countries/domain/country.dart';
import '../domain/weather.dart';
import '../domain/weather_repository.dart';
import 'weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._remote);

  final WeatherRemoteDataSource _remote;

  @override
  Future<Weather> getCurrentWeather(Coordinates coordinates) {
    return _remote.fetchCurrentWeather(coordinates);
  }
}
