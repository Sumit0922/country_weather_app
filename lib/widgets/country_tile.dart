import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/countries/domain/country.dart';
import '../features/favorites/presentation/favorite_button.dart';
import 'country_flag.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    required this.country,
    required this.userId,
    required this.onTap,
    super.key,
  });

  final Country country;
  final String userId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final capital = country.capitals.isEmpty
        ? AppStrings.unavailable
        : country.capitals.join(AppStrings.listSeparator);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(14.r.clamp(10.0, 20.0).toDouble()),
          child: Row(
            children: [
              CountryFlag(
                url: country.flagUrl,
                countryName: country.name,
                width: 56,
                height: 40,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      capital,
                      style: TextStyle(
                        fontSize: 12.spMin,
                        color: AppColors.muted,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      country.region ?? AppStrings.unavailable,
                      style: TextStyle(
                        fontSize: 11.spMin,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              FavoriteButton(userId: userId, countryCode: country.code),
            ],
          ),
        ),
      ),
    );
  }
}
