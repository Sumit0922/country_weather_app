import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../core/config/app_config.dart';
import '../core/network/dio_client.dart';

import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/domain/app_user.dart';
import '../features/auth/domain/auth_repository.dart';

import '../features/countries/data/country_local_data_source.dart';
import '../features/countries/data/country_remote_data_source.dart';
import '../features/countries/data/country_repository_impl.dart';
import '../features/countries/domain/country_repository.dart';

import '../features/favorites/data/hive_favorites_repository.dart';
import '../features/favorites/domain/favorites_repository.dart';

import '../features/weather/data/weather_remote_data_source.dart';
import '../features/weather/data/weather_repository_impl.dart';
import '../features/weather/domain/weather_repository.dart';

// Local storage.
final storageBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box<dynamic>(AppConfig.storageBox),
);

// Authentication.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(FirebaseAuth.instance),
);

final authSessionProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).watchUser(),
  retry: (retryCount, error) => null,
);

// Separate HTTP clients for each service.
final countriesDioProvider = Provider<Dio>((ref) {
  final dio = DioClient.create(AppConfig.countriesBaseUrl);

  ref.onDispose(() {
    dio.close(force: true);
  });

  return dio;
});

final weatherDioProvider = Provider<Dio>((ref) {
  final dio = DioClient.create(AppConfig.weatherBaseUrl);

  ref.onDispose(() {
    dio.close(force: true);
  });

  return dio;
});

// Country data sources.
final countryRemoteProvider = Provider<CountryRemoteDataSource>(
  (ref) => DioCountryRemoteDataSource(ref.watch(countriesDioProvider)),
);

final countryLocalProvider = Provider<CountryLocalDataSource>(
  (ref) => HiveCountryLocalDataSource(ref.watch(storageBoxProvider)),
);

// Country repository.
final countryRepositoryProvider = Provider<CountryRepository>(
  (ref) => CountryRepositoryImpl(
    remote: ref.watch(countryRemoteProvider),
    local: ref.watch(countryLocalProvider),
  ),
);

// Weather data source.
final weatherRemoteProvider = Provider<WeatherRemoteDataSource>(
  (ref) => DioWeatherRemoteDataSource(ref.watch(weatherDioProvider)),
);

// Weather repository.
final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.watch(weatherRemoteProvider)),
);

// Favorites are stored separately for each Firebase user.
final favoritesRepositoryProvider =
    Provider.family<FavoritesRepository, String>(
      (ref, userId) => HiveFavoritesRepository(
        box: ref.watch(storageBoxProvider),
        userId: userId,
      ),
    );
