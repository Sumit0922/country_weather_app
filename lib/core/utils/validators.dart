import '../constants/app_strings.dart';

abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value) {
    final email = value?.trim() ?? AppStrings.empty;

    if (email.isEmpty) {
      return AppStrings.requiredEmail;
    }

    if (!_emailPattern.hasMatch(email)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredPassword;
    }

    return null;
  }
}
