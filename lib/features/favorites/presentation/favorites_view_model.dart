import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/dependencies.dart';

final favoritesProvider =
    NotifierProvider.family<FavoritesViewModel, Set<String>, String>(
      FavoritesViewModel.new,
    );

class FavoritesViewModel extends Notifier<Set<String>> {
  FavoritesViewModel(this.userId);

  final String userId;
  Future<void> _pending = Future<void>.value();

  @override
  Set<String> build() {
    return ref.watch(favoritesRepositoryProvider(userId)).readFavorites();
  }

  Future<void> toggle(String countryCode) {
    final repository = ref.read(favoritesRepositoryProvider(userId));

    // Serialize writes so rapid taps cannot overwrite a newer favorite set.
    final operation = _pending.then((_) async {
      final next = {...state};

      if (!next.add(countryCode)) {
        next.remove(countryCode);
      }

      await repository.saveFavorites(next);

      if (ref.mounted) {
        state = Set<String>.unmodifiable(next);
      }
    });

    _pending = operation.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return operation;
  }
}
