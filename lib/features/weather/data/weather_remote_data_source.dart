import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/api_fields.dart';
import '../../../core/network/dio_client.dart';
import '../../countries/domain/country.dart';
import '../domain/weather.dart';
import 'weather_model.dart';

abstract interface class WeatherRemoteDataSource {
  Future<Weather> fetchCurrentWeather(Coordinates coordinates);
}

class DioWeatherRemoteDataSource implements WeatherRemoteDataSource {
  DioWeatherRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<Weather> fetchCurrentWeather(Coordinates coordinates) async {
    try {
      final response = await _dio.get<Object?>(
        AppConfig.weatherPath,
        queryParameters: {
          ApiFields.latitude: coordinates.latitude,
          ApiFields.longitude: coordinates.longitude,
          ApiFields.current: AppConfig.currentWeatherFields,
          ApiFields.windSpeedUnit: ApiFields.kmh,
          ApiFields.timezone: ApiFields.auto,
        },
      );

      return WeatherModel.fromJson(response.data);
    } on DioException catch (error) {
      throw NetworkError.from(error);
    }
  }
}
