import 'package:hive/hive.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/favorites_repository.dart';

class HiveFavoritesRepository implements FavoritesRepository {
  HiveFavoritesRepository({required this._box, required String userId})
    : _key = '${AppConfig.favoritesPrefix}$userId';

  final Box<dynamic> _box;
  final String _key;

  @override
  Set<String> readFavorites() {
    try {
      final value = _box.get(_key);

      if (value is! List) {
        return const <String>{};
      }

      return Set<String>.unmodifiable(value.whereType<String>());
    } catch (_) {
      return const <String>{};
    }
  }

  @override
  Future<void> saveFavorites(Set<String> countryCodes) async {
    try {
      final values = countryCodes.toList()..sort();
      await _box.put(_key, values);
    } catch (_) {
      throw const AppException(AppStrings.storageError);
    }
  }
}
