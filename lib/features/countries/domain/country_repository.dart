import 'country.dart';

abstract interface class CountryRepository {
  Future<CountryCatalog> getCountries();
}
