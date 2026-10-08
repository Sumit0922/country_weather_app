import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/dependencies.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../countries/domain/country.dart';
import '../domain/weather.dart';

final weatherProvider = FutureProvider.autoDispose.family<Weather, Country>((
  ref,
  country,
) {
  final coordinates = country.coordinates;

  if (coordinates == null) {
    throw const AppException(AppStrings.noCoordinatesMessage);
  }

  return ref.watch(weatherRepositoryProvider).getCurrentWeather(coordinates);
}, retry: (retryCount, error) => null);
