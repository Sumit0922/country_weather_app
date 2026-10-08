import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/country.dart';
import 'country_api_adapter.dart';
import 'country_model.dart';

abstract interface class CountryRemoteDataSource {
  Future<List<Country>> fetchCountries();
}

class DioCountryRemoteDataSource implements CountryRemoteDataSource {
  DioCountryRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<Country>> fetchCountries() async {
    final cancelToken = CancelToken();

    try {
      final response = await _dio
          .get<String>(
            AppConfig.countriesPath,
            cancelToken: cancelToken,
            options: Options(responseType: ResponseType.plain),
          )
          .timeout(
            AppConfig.timeout,
            onTimeout: () {
              cancelToken.cancel(AppStrings.timeoutError);

              throw TimeoutException(AppStrings.timeoutError);
            },
          );

      final body = response.data;

      if (body == null || body.trim().isEmpty) {
        throw const AppException(AppStrings.invalidResponse);
      }

      final Object? decoded = jsonDecode(body);

      final normalized = CountryApiAdapter.normalize(decoded);

      final countries = CountryModel.parseList(normalized);

      if (kDebugMode) {
        debugPrint(AppStrings.countriesLoaded(countries.length));
      }

      return countries;
    } on DioException catch (error) {
      throw NetworkError.from(error);
    } on TimeoutException {
      throw const AppException(AppStrings.timeoutError);
    } on FormatException catch (error) {
      _logParsingError(error);

      throw const AppException(AppStrings.invalidResponse);
    } on AppException catch (error) {
      _logParsingError(error);
      rethrow;
    } catch (error) {
      _logParsingError(error);

      throw const AppException(AppStrings.invalidResponse);
    }
  }

  void _logParsingError(Object error) {
    if (kDebugMode) {
      debugPrint(AppStrings.countryParsingFailed(error));
    }
  }
}
