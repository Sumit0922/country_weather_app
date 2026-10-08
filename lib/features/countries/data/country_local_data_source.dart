import 'package:country_weather_explorer/core/config/app_config.dart';
import '../domain/country.dart';
import 'country_model.dart';
import 'package:hive/hive.dart';

abstract interface class CountryLocalDataSource {
  List<Country> readCountries();
  Future<void> saveCountries(List<Country> countries);
}

class HiveCountryLocalDataSource implements CountryLocalDataSource {
  HiveCountryLocalDataSource(this._box);

  final Box<dynamic> _box;

  @override
  List<Country> readCountries() {
    try {
      final cached = _box.get(AppConfig.countryCacheKey);
      if (cached == null) return const [];
      return CountryModel.parseList(cached);
    } catch (_) {
      // Corrupt or incompatible cache must not prevent a network request.
      return const [];
    }
  }

  @override
  Future<void> saveCountries(List<Country> countries) {
    return _box.put(
      AppConfig.countryCacheKey,
      countries.map(CountryModel.toJson).toList(growable: false),
    );
  }
}
