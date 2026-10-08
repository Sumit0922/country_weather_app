import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';

import '../../../widgets/app_feedback.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/app_state_view.dart';
import '../../../widgets/country_list_skeleton.dart';
import '../../../widgets/country_tile.dart';

import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../../favorites/presentation/favorites_view_model.dart';

import '../domain/country.dart';
import 'countries_view_model.dart';
import 'country_details_screen.dart';

class CountriesScreen extends ConsumerStatefulWidget {
  const CountriesScreen({required this.user, super.key});

  final AppUser user;

  @override
  ConsumerState<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends ConsumerState<CountriesScreen> {
  final _searchController = TextEditingController();
  final _listController = ScrollController();

  bool _favoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _resetListPosition() {
    if (_listController.hasClients) {
      _listController.jumpTo(0);
    }
  }

  void _clearSearch() {
    _searchController.clear();

    ref.read(countrySearchProvider.notifier).update(AppStrings.empty);

    _resetListPosition();
  }

  void _updateSearch(String value) {
    ref.read(countrySearchProvider.notifier).update(value);

    _resetListPosition();
  }

  void _selectFilter(bool favoritesOnly) {
    if (_favoritesOnly == favoritesOnly) {
      return;
    }

    _resetListPosition();

    setState(() {
      _favoritesOnly = favoritesOnly;
    });
  }

  Future<void> _refresh() {
    return ref.read(countriesProvider.notifier).refresh();
  }

  Future<void> _confirmLogout() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          icon: const Icon(Icons.logout, color: AppColors.primary),
          title: const Text(AppStrings.logoutTitle),
          content: const Text(AppStrings.logoutMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(AppStrings.signOut),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await ref.read(authActionProvider.notifier).signOut();

    if (!mounted) {
      return;
    }

    final error = ref.read(authActionProvider).error;

    if (error != null) {
      AppFeedback.error(ErrorMessage.from(error));
    }
  }

  void _openCountry(Country country) {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CountryDetailsScreen(country: country, userId: widget.user.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesProvider);
    final query = ref.watch(countrySearchProvider);
    final favorites = ref.watch(favoritesProvider(widget.user.id));
    final authAction = ref.watch(authActionProvider);

    final visibleCountries = ref.watch(
      visibleCountriesProvider(_favoritesOnly ? favorites : null),
    );

    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    final horizontalPadding = 20.r.clamp(14.0, 28.0).toDouble();

    final initialCountUnknown =
        countriesState.isLoading &&
        countriesState.value == null &&
        visibleCountries.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 19.spMin, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.refresh,
            onPressed: countriesState.isLoading
                ? null
                : () {
                    _refresh();
                  },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: AppStrings.signOut,
            onPressed: authAction.isLoading ? null : _confirmLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConfig.contentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compactHeader =
                      keyboardOpen || constraints.maxHeight < 500;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fixed header in the normal portrait layout.
                      // Its height is bounded for small windows.
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.65,
                        ),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: compactHeader ? 8.r : 16.r,
                              bottom: 12.r,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!compactHeader) ...[
                                  Text(
                                    AppStrings.explore,
                                    style: TextStyle(
                                      fontSize: 28.spMin,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    AppStrings.exploreSubtitle,
                                    style: TextStyle(
                                      fontSize: 13.spMin,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  22.verticalSpace,
                                ],
                                TextField(
                                  controller: _searchController,
                                  onChanged: _updateSearch,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchHint,
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: query.isEmpty
                                        ? null
                                        : IconButton(
                                            tooltip: AppStrings.clearSearch,
                                            onPressed: _clearSearch,
                                            icon: const Icon(Icons.close),
                                          ),
                                  ),
                                ),
                                14.verticalSpace,
                                Wrap(
                                  spacing: 10.r,
                                  runSpacing: 8.r,
                                  children: [
                                    _CountryFilterChip(
                                      label: AppStrings.allCountries,
                                      selected: !_favoritesOnly,
                                      onTap: () {
                                        _selectFilter(false);
                                      },
                                    ),
                                    _CountryFilterChip(
                                      label: AppStrings.favorites,
                                      icon: _favoritesOnly
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      selected: _favoritesOnly,
                                      onTap: () {
                                        _selectFilter(true);
                                      },
                                    ),
                                  ],
                                ),
                                if (countriesState.value?.fromCache ==
                                    true) ...[
                                  12.verticalSpace,
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySoft,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      AppStrings.cachedCountries,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12.spMin,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Fixed country count: outside the list.
                      Padding(
                        padding: EdgeInsets.only(top: 2.r, bottom: 14.r),
                        child: initialCountUnknown
                            ? AppShimmer(
                                child: SkeletonBox(width: 110.r, height: 14.r),
                              )
                            : Text(
                                query.trim().isEmpty
                                    ? AppStrings.countryCount(
                                        visibleCountries.length,
                                      )
                                    : AppStrings.resultsCount(
                                        visibleCountries.length,
                                      ),
                                style: TextStyle(
                                  fontSize: 12.spMin,
                                  color: AppColors.muted,
                                ),
                              ),
                      ),

                      // Only this list section scrolls normally.
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          color: AppColors.primary,
                          backgroundColor: AppColors.surface,
                          child: _buildList(
                            countriesState: countriesState,
                            visibleCountries: visibleCountries,
                            query: query,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList({
    required AsyncValue<CountryCatalog> countriesState,
    required List<Country> visibleCountries,
    required String query,
  }) {
    // Check isLoading directly so refresh also displays skeletons,
    // even though the previous country data is retained.
    if (countriesState.isLoading) {
      return CountryListSkeleton(
        controller: _listController,
        countries: visibleCountries,
      );
    }

    if (countriesState.hasError) {
      return _ScrollableState(
        controller: _listController,
        child: AppStateView(
          title: AppStrings.countryLoadError,
          message: ErrorMessage.from(countriesState.error!),
          onRetry: () {
            _refresh();
          },
        ),
      );
    }

    final catalog = countriesState.value;

    if (catalog == null || catalog.countries.isEmpty) {
      return _ScrollableState(
        controller: _listController,
        child: AppStateView(
          title: AppStrings.noCountries,
          message: AppStrings.noCountriesMessage,
          onRetry: () {
            _refresh();
          },
        ),
      );
    }

    if (visibleCountries.isEmpty) {
      final emptyFavorites = _favoritesOnly && query.trim().isEmpty;

      return _ScrollableState(
        controller: _listController,
        child: AppStateView(
          title: emptyFavorites ? AppStrings.noFavorites : AppStrings.noResults,
          message: emptyFavorites
              ? AppStrings.noFavoritesMessage
              : AppStrings.noResultsMessage,
          icon: emptyFavorites ? Icons.favorite_border : Icons.search_off,
        ),
      );
    }

    return ListView.separated(
      controller: _listController,
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(bottom: 24.r),
      itemCount: visibleCountries.length,
      separatorBuilder: (_, index) => 10.verticalSpace,
      itemBuilder: (context, index) {
        final country = visibleCountries[index];

        return CountryTile(
          key: ValueKey(country.code),
          country: country,
          userId: widget.user.id,
          onTap: () {
            _openCountry(country);
          },
        );
      },
    );
  }
}

class _CountryFilterChip extends StatelessWidget {
  const _CountryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,

      // Prevent the automatic selected checkmark.
      showCheckmark: false,

      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primarySoft,
      side: BorderSide(
        color: selected ? AppColors.primarySoft : AppColors.border,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18.r, color: AppColors.primary),
            7.horizontalSpace,
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13.spMin,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.text,
            ),
          ),
        ],
      ),
      onSelected: (_) {
        onTap();
      },
    );
  }
}

class _ScrollableState extends StatelessWidget {
  const _ScrollableState({required this.controller, required this.child});

  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [SizedBox(height: constraints.maxHeight, child: child)],
        );
      },
    );
  }
}
