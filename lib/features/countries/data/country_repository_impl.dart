import '../domain/country.dart';
import '../domain/country_repository.dart';
import 'country_local_data_source.dart';
import 'country_remote_data_source.dart';

class CountryRepositoryImpl implements CountryRepository {
  CountryRepositoryImpl({
    required this._remote,
    required this._local,
  });

  final CountryRemoteDataSource _remote;
  final CountryLocalDataSource _local;

  @override
  Future<CountryCatalog> getCountries() async {
    final List<Country> countries;

    try {
      countries = await _remote.fetchCountries();
    } catch (_) {
      final cached = _local.readCountries();

      if (cached.isNotEmpty) {
        return CountryCatalog(countries: cached, fromCache: true);
      }

      rethrow;
    }

    try {
      await _local.saveCountries(countries);
    } catch (_) {
      // A cache failure must not discard valid network data.
    }

    return CountryCatalog(countries: countries);
  }
}
