import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/countries/domain/country.dart';
import 'app_shimmer.dart';

class CountryListSkeleton extends StatelessWidget {
  const CountryListSkeleton({
    required this.controller,
    this.countries = const [],
    super.key,
  });

  final ScrollController controller;
  final List<Country> countries;

  @override
  Widget build(BuildContext context) {
    final itemCount = countries.isEmpty ? 8 : countries.length;

    return Semantics(
      container: true,
      label: AppStrings.loadingCountries,
      child: ExcludeSemantics(
        child: ListView.separated(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 24.r),
          itemCount: itemCount,
          separatorBuilder: (_, index) => 10.verticalSpace,
          itemBuilder: (_, index) => const _CountryTileSkeleton(),
        ),
      ),
    );
  }
}

class _CountryTileSkeleton extends StatelessWidget {
  const _CountryTileSkeleton();

  @override
  Widget build(BuildContext context) {
    final padding = 14.r.clamp(10.0, 20.0).toDouble();
    final flagWidth = 56.r.clamp(44.8, 67.2).toDouble();
    final flagHeight = 40.r.clamp(32.0, 48.0).toDouble();

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: AppShimmer(
        child: Row(
          children: [
            // Always show a skeleton flag while refreshing.
            SkeletonBox(width: flagWidth, height: flagHeight, radius: 8.r),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.76,
                    child: SkeletonBox(height: 18.r),
                  ),
                  7.verticalSpace,
                  FractionallySizedBox(
                    widthFactor: 0.52,
                    child: SkeletonBox(height: 13.r),
                  ),
                  7.verticalSpace,
                  FractionallySizedBox(
                    widthFactor: 0.32,
                    child: SkeletonBox(height: 11.r),
                  ),
                ],
              ),
            ),
            12.horizontalSpace,
            Padding(
              padding: EdgeInsets.all(10.r),
              child: SkeletonBox(width: 24.r, height: 24.r, radius: 12.r),
            ),
          ],
        ),
      ),
    );
  }
}
