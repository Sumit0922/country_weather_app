import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../constants/api_fields.dart';
import '../constants/app_strings.dart';
import '../errors/app_exception.dart';

abstract final class DioClient {
  static Dio create(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConfig.timeout,
        receiveTimeout: AppConfig.timeout,
        sendTimeout: AppConfig.timeout,
        responseType: ResponseType.json,
        headers: {ApiFields.acceptHeader: ApiFields.jsonContentType},
      ),
    );

    dio.interceptors.add(ApiErrorInterceptor());

    return dio;
  }
}

class ApiErrorInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(AppStrings.apiRequest(options.method, options.uri));
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;

    final message = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => AppStrings.timeoutError,

      DioExceptionType.connectionError => AppStrings.networkError,

      DioExceptionType.cancel => AppStrings.cancelled,

      DioExceptionType.badCertificate => AppStrings.networkError,

      DioExceptionType.badResponse =>
        status != null
            ? AppStrings.serviceStatus(status)
            : AppStrings.requestError,

      DioExceptionType.unknown =>
        err.error is FormatException
            ? AppStrings.invalidResponse
            : AppStrings.networkError,

      // Includes transformTimeout in newer Dio versions.
      _ => AppStrings.timeoutError,
    };

    if (kDebugMode) {
      debugPrint(
        AppStrings.apiFailure(
          err.requestOptions.uri,
          status,
          err.type.name,
        ),
      );
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: AppException(message),
        message: message,
        stackTrace: err.stackTrace,
      ),
    );
  }
}

abstract final class NetworkError {
  static AppException from(DioException error) {
    final mapped = error.error;

    return mapped is AppException
        ? mapped
        : const AppException(AppStrings.requestError);
  }
}
