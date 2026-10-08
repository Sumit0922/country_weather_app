class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class CountryCurrency {
  const CountryCurrency({required this.code, required this.name, this.symbol});

  final String code;
  final String name;
  final String? symbol;
}

class Country {
  const Country({
    required this.code,
    required this.name,
    required this.capitals,
    required this.currencies,
    this.flagUrl,
    this.region,
    this.population,
    this.coordinates,
  });

  final String code;
  final String name;
  final String? flagUrl;
  final List<String> capitals;
  final String? region;
  final int? population;
  final List<CountryCurrency> currencies;
  final Coordinates? coordinates;
}

class CountryCatalog {
  const CountryCatalog({required this.countries, this.fromCache = false});

  final List<Country> countries;
  final bool fromCache;
}
