import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/dependencies.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/country.dart';

final countriesProvider =
    AsyncNotifierProvider<CountriesViewModel, CountryCatalog>(
      CountriesViewModel.new,
      retry: (retryCount, error) => null,
    );

class CountriesViewModel extends AsyncNotifier<CountryCatalog> {
  @override
  Future<CountryCatalog> build() {
    return ref.watch(countryRepositoryProvider).getCountries();
  }

  Future<void> refresh() async {
    if (state.isLoading) {
      return;
    }

    final repository = ref.read(countryRepositoryProvider);
    final previous = state;

    state = const AsyncLoading<CountryCatalog>().copyWithPrevious(previous);

    final result = await AsyncValue.guard<CountryCatalog>(
      repository.getCountries,
    );

    if (!ref.mounted) {
      return;
    }

    state = result.copyWithPrevious(previous);
  }
}

// Stored countries are used as visual seeds while the API loads.
final cachedCountriesProvider = Provider<List<Country>>((ref) {
  return ref.watch(countryLocalProvider).readCountries();
});

final countrySearchProvider =
    NotifierProvider.autoDispose<CountrySearchViewModel, String>(
      CountrySearchViewModel.new,
    );

class CountrySearchViewModel extends Notifier<String> {
  @override
  String build() => AppStrings.empty;

  void update(String query) {
    state = query;
  }
}

final visibleCountriesProvider = Provider.autoDispose
    .family<List<Country>, Set<String>?>((ref, favoriteCodes) {
      final catalog = ref.watch(countriesProvider).value;

      final countries =
          catalog?.countries ?? ref.watch(cachedCountriesProvider);

      final query = ref.watch(countrySearchProvider).trim().toLowerCase();

      return countries!
          .where((country) {
            final matchesQuery =
                query.isEmpty || country.name.toLowerCase().contains(query);

            final matchesFavorites =
                favoriteCodes == null || favoriteCodes.contains(country.code);

            return matchesQuery && matchesFavorites;
          })
          .toList(growable: false);
    });
