import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/app_state_view.dart';
import '../../../widgets/content_card.dart';
import '../../../widgets/country_flag.dart';
import '../../../widgets/country_map.dart';
import '../../favorites/presentation/favorite_button.dart';
import '../../weather/presentation/weather_card.dart';
import '../domain/country.dart';

class CountryDetailsScreen extends StatelessWidget {
  const CountryDetailsScreen({
    required this.country,
    required this.userId,
    super.key,
  });

  final Country country;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final coordinates = country.coordinates;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          country.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 19.spMin, fontWeight: FontWeight.w700),
        ),
        actions: [FavoriteButton(userId: userId, countryCode: country.code)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r.clamp(14.0, 28.0).toDouble()),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConfig.contentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryFlag(
                          url: country.flagUrl,
                          countryName: country.name,
                          width: 112,
                          height: 76,
                        ),
                        18.verticalSpace,
                        Text(
                          country.name,
                          style: TextStyle(
                            fontSize: 28.spMin,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          country.region ?? AppStrings.unavailable,
                          style: TextStyle(
                            fontSize: 14.spMin,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  18.verticalSpace,
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final overview = _CountryOverview(country: country);

                      final weather = coordinates == null
                          ? const ContentCard(
                              child: AppStateView(
                                title: AppStrings.noCoordinates,
                                message: AppStrings.noCoordinatesMessage,
                                icon: Icons.location_off_outlined,
                              ),
                            )
                          : WeatherCard(country: country);

                      if (constraints.maxWidth >= 760) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: overview),
                            16.horizontalSpace,
                            Expanded(child: weather),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [overview, 18.verticalSpace, weather],
                      );
                    },
                  ),
                  if (coordinates != null) ...[
                    18.verticalSpace,
                    CountryMap(
                      coordinates: coordinates,
                      countryName: country.name,
                    ),
                  ],
                  16.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryOverview extends StatelessWidget {
  const _CountryOverview({required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat(
      AppStrings.decimalPattern,
      AppStrings.locale,
    );

    final coordinates = country.coordinates;

    final rows = <(String, String)>[
      (
        AppStrings.capital,
        country.capitals.isEmpty
            ? AppStrings.unavailable
            : country.capitals.join(AppStrings.listSeparator),
      ),
      (AppStrings.region, country.region ?? AppStrings.unavailable),
      (
        AppStrings.population,
        country.population == null
            ? AppStrings.unavailable
            : formatter.format(country.population),
      ),
      (
        AppStrings.currency,
        country.currencies.isEmpty
            ? AppStrings.unavailable
            : country.currencies
                  .map(
                    (currency) => AppStrings.currencyValue(
                      currency.name,
                      currency.code,
                      currency.symbol,
                    ),
                  )
                  .join(AppStrings.listSeparator),
      ),
      (
        AppStrings.latitude,
        coordinates == null
            ? AppStrings.unavailable
            : AppStrings.coordinateValue(coordinates.latitude),
      ),
      (
        AppStrings.longitude,
        coordinates == null
            ? AppStrings.unavailable
            : AppStrings.coordinateValue(coordinates.longitude),
      ),
    ];

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.countryOverview,
            style: TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.w700),
          ),
          14.verticalSpace,
          for (var index = 0; index < rows.length; index++) ...[
            _OverviewRow(label: rows[index].$1, value: rows[index].$2),
            if (index < rows.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      style: TextStyle(fontSize: 12.spMin, color: AppColors.muted),
    );

    final valueWidget = Text(
      value,
      style: TextStyle(
        fontSize: 14.spMin,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.r),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;

          if (constraints.maxWidth < 280 || textScale > 1.4) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [labelWidget, 5.verticalSpace, valueWidget],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 90, child: labelWidget),
              12.horizontalSpace,
              Expanded(child: valueWidget),
            ],
          );
        },
      ),
    );
  }
}
