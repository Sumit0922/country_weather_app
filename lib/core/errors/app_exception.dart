import '../constants/app_strings.dart';

class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract final class ErrorMessage {
  static String from(Object error) {
    return error is AppException ? error.message : AppStrings.unexpectedError;
  }
}
