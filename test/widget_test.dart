import 'package:flutter_test/flutter_test.dart';

import 'package:country_weather_explorer/core/constants/api_fields.dart';
import 'package:country_weather_explorer/core/errors/app_exception.dart';
import 'package:country_weather_explorer/features/countries/data/country_model.dart';
import 'package:country_weather_explorer/features/weather/data/weather_model.dart';

void main() {
  group('Country parsing', () {
    test('missing optional values do not crash', () {
      final country = CountryModel.fromJson({
        ApiFields.cca2: 'IN',
        ApiFields.name: {ApiFields.common: 'India'},
      });

      expect(country.name, 'India');
      expect(country.capitals, isEmpty);
      expect(country.currencies, isEmpty);
      expect(country.population, isNull);
      expect(country.coordinates, isNull);
      expect(country.flagUrl, isNull);
    });

    test('invalid coordinates are not exposed to weather or map', () {
      final country = CountryModel.fromJson({
        ApiFields.cca2: 'IN',
        ApiFields.name: {ApiFields.common: 'India'},
        ApiFields.latlng: [120, 500],
      });

      expect(country.coordinates, isNull);
    });

    test('valid countries survive malformed list entries', () {
      final countries = CountryModel.parseList([
        {
          ApiFields.cca2: 'IN',
          ApiFields.name: {ApiFields.common: 'India'},
        },
        {ApiFields.population: 100},
        null,
      ]);

      expect(countries, hasLength(1));
      expect(countries.single.code, 'IN');
    });

    test('a malformed nonempty response produces an error', () {
      expect(
        () => CountryModel.parseList([
          {ApiFields.population: 100},
        ]),
        throwsA(isA<AppException>()),
      );
    });

    test('cache serialization preserves required country details', () {
      final original = CountryModel.fromJson({
        ApiFields.cca2: 'IN',
        ApiFields.name: {ApiFields.common: 'India'},
        ApiFields.capital: ['New Delhi'],
        ApiFields.population: 1400000000,
        ApiFields.latlng: [20, 77],
        ApiFields.currencies: {
          'INR': {ApiFields.name: 'Indian rupee', ApiFields.symbol: '₹'},
        },
      });

      final restored = CountryModel.fromJson(CountryModel.toJson(original));

      expect(restored.code, original.code);
      expect(restored.capitals, original.capitals);
      expect(restored.population, original.population);
      expect(restored.coordinates?.latitude, 20);
      expect(restored.currencies.single.code, 'INR');
    });
  });

  group('Weather parsing', () {
    test('parses all required current weather values', () {
      final weather = WeatherModel.fromJson({
        ApiFields.current: {
          ApiFields.temperature: 28.5,
          ApiFields.humidity: 65,
          ApiFields.windSpeed: 12.4,
          ApiFields.weatherCode: 2,
        },
      });

      expect(weather.temperature, 28.5);
      expect(weather.humidity, 65);
      expect(weather.windSpeed, 12.4);
      expect(weather.code, 2);
    });

    test('rejects missing weather values', () {
      expect(
        () => WeatherModel.fromJson({
          ApiFields.current: {ApiFields.temperature: 28},
        }),
        throwsA(isA<AppException>()),
      );
    });

    test('rejects humidity outside its valid range', () {
      expect(
        () => WeatherModel.fromJson({
          ApiFields.current: {
            ApiFields.temperature: 28,
            ApiFields.humidity: 150,
            ApiFields.windSpeed: 10,
            ApiFields.weatherCode: 0,
          },
        }),
        throwsA(isA<AppException>()),
      );
    });
  });
}
