import '../../../core/constants/api_fields.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';

abstract final class CountryApiAdapter {
  static List<Map<String, dynamic>> normalize(Object? response) {
    if (response is! List) {
      throw const AppException(AppStrings.invalidResponse);
    }

    final normalized = <Map<String, dynamic>>[];

    for (final item in response) {
      if (item is! Map) {
        continue;
      }

      final json = _stringMap(item);

      final rawName = json[ApiFields.name];
      final rawCapital = json[ApiFields.capital];
      final rawCurrencies = json[ApiFields.currencies];

      // The existing CountryModel expects name.common.
      final Object? name = rawName is String
          ? <String, dynamic>{ApiFields.common: rawName}
          : rawName;

      // The existing CountryModel expects a list of capitals.
      final Object? capitals = rawCapital is String
          ? <String>[if (rawCapital.trim().isNotEmpty) rawCapital.trim()]
          : rawCapital;

      // The existing CountryModel expects currencies keyed by code.
      final currencies = <String, dynamic>{};

      if (rawCurrencies is List) {
        for (final currencyItem in rawCurrencies) {
          if (currencyItem is! Map) {
            continue;
          }

          final currency = _stringMap(currencyItem);

          final code = currency[ApiFields.currencyCode];

          if (code is! String || code.trim().isEmpty) {
            continue;
          }

          currencies[code.trim()] = <String, dynamic>{
            ApiFields.name: currency[ApiFields.name],
            ApiFields.symbol: currency[ApiFields.symbol],
          };
        }
      } else if (rawCurrencies is Map) {
        currencies.addAll(_stringMap(rawCurrencies));
      }

      normalized.add(<String, dynamic>{
        ApiFields.name: name,
        ApiFields.cca2: json[ApiFields.alpha2Code] ?? json[ApiFields.cca2],
        ApiFields.flags: json[ApiFields.flags],
        ApiFields.capital: capitals,
        ApiFields.region: json[ApiFields.region],
        ApiFields.population: json[ApiFields.population],
        ApiFields.currencies: currencies,
        ApiFields.latlng: json[ApiFields.latlng],
      });
    }

    if (response.isNotEmpty && normalized.isEmpty) {
      throw const AppException(AppStrings.invalidResponse);
    }

    return normalized;
  }

  static Map<String, dynamic> _stringMap(Map<dynamic, dynamic> value) {
    return <String, dynamic>{
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
}
