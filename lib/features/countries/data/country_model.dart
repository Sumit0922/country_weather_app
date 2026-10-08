import '../../../core/constants/api_fields.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/country.dart';

class CountryModel {
  const CountryModel._();

  static Country fromJson(Map<String, dynamic> json) {
    final nameData = _map(json[ApiFields.name]);
    final name = _text(nameData[ApiFields.common]);
    final code = _text(json[ApiFields.cca2]);

    if (name == null || code == null) {
      throw const AppException(AppStrings.invalidResponse);
    }

    final capitalsValue = json[ApiFields.capital];
    final capitals = capitalsValue is List
        ? capitalsValue
              .whereType<String>()
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toList(growable: false)
        : <String>[];

    final currencies = <CountryCurrency>[];
    final currencyData = _map(json[ApiFields.currencies]);

    for (final entry in currencyData.entries) {
      final details = _map(entry.value);
      currencies.add(
        CountryCurrency(
          code: entry.key,
          name: _text(details[ApiFields.name]) ?? entry.key,
          symbol: _text(details[ApiFields.symbol]),
        ),
      );
    }

    Coordinates? coordinates;
    final position = json[ApiFields.latlng];

    if (position is List && position.length >= 2) {
      final lat = _number(position[0]);
      final lng = _number(position[1]);

      if (lat != null &&
          lng != null &&
          lat.isFinite &&
          lng.isFinite &&
          lat >= -90 &&
          lat <= 90 &&
          lng >= -180 &&
          lng <= 180) {
        coordinates = Coordinates(latitude: lat, longitude: lng);
      }
    }

    final rawPopulation = _number(json[ApiFields.population]);
    final population =
        rawPopulation != null && rawPopulation.isFinite && rawPopulation >= 0
        ? rawPopulation.toInt()
        : null;

    final rawFlag = _text(_map(json[ApiFields.flags])[ApiFields.png]);
    final flagUri = rawFlag == null ? null : Uri.tryParse(rawFlag);
    final flagUrl =
        flagUri != null && flagUri.scheme ==  ApiFields.https && flagUri.host.isNotEmpty
        ? rawFlag
        : null;

    return Country(
      code: code.toUpperCase(),
      name: name,
      flagUrl: flagUrl,
      capitals: List.unmodifiable(capitals),
      region: _text(json[ApiFields.region]),
      population: population,
      currencies: List.unmodifiable(currencies),
      coordinates: coordinates,
    );
  }

  static List<Country> parseList(Object? response) {
    if (response is! List) {
      throw const AppException(AppStrings.invalidResponse);
    }

    if (response.isEmpty) return const [];

    final countries = <String, Country>{};

    for (final item in response) {
      if (item is! Map) continue;

      try {
        final json = Map<String, dynamic>.from(item);
        final country = fromJson(json);
        countries[country.code] = country;
      } on AppException {
        // One malformed entry does not discard the valid entries.
      } on TypeError {
        // Ignore entries with invalid key types.
      }
    }

    if (countries.isEmpty) {
      throw const AppException(AppStrings.invalidResponse);
    }

    final sorted = countries.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return List.unmodifiable(sorted);
  }

  static Map<String, dynamic> toJson(Country country) {
    return {
      ApiFields.cca2: country.code,
      ApiFields.name: {ApiFields.common: country.name},
      ApiFields.flags: {ApiFields.png: country.flagUrl},
      ApiFields.capital: country.capitals,
      ApiFields.region: country.region,
      ApiFields.population: country.population,
      ApiFields.currencies: {
        for (final currency in country.currencies)
          currency.code: {
            ApiFields.name: currency.name,
            ApiFields.symbol: currency.symbol,
          },
      },
      ApiFields.latlng: country.coordinates == null
          ? null
          : [country.coordinates!.latitude, country.coordinates!.longitude],
    };
  }

  static Map<String, dynamic> _map(Object? value) {
    if (value is! Map) return {};
    return {
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }

  static String? _text(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    return value.trim();
  }

  static double? _number(Object? value) {
    return value is num ? value.toDouble() : null;
  }
}
