import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'app_shimmer.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({
    required this.url,
    required this.countryName,
    this.width = 64,
    this.height = 44,
    super.key,
  });

  final String? url;
  final String countryName;
  final double width;
  final double height;

  Widget _fallback() {
    return const ColoredBox(
      color: AppColors.primarySoft,
      child: Center(
        child: Icon(
          Icons.flag_outlined,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _loading(double imageWidth, double imageHeight) {
    return AppShimmer(
      child: SkeletonBox(
        width: imageWidth,
        height: imageHeight,
        radius: 8.r,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = width.r
        .clamp(width * 0.8, width * 1.2)
        .toDouble();

    final imageHeight = height.r
        .clamp(height * 0.8, height * 1.2)
        .toDouble();

    final imageUrl = url?.trim();
    final hasUrl = imageUrl != null && imageUrl.isNotEmpty;

    return Semantics(
      label: AppStrings.flagLabel(countryName),
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: !hasUrl
              ? _fallback()
              : Image.network(
            imageUrl,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain,
            excludeFromSemantics: true,

            // Display shimmer until the first image frame is ready.
            frameBuilder: (
                context,
                child,
                frame,
                wasSynchronouslyLoaded,
                ) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }

              return _loading(imageWidth, imageHeight);
            },

            // Show a fallback if downloading or decoding fails.
            errorBuilder: (context, error, stackTrace) {
              return _fallback();
            },
          ),
        ),
      ),
    );
  }
}