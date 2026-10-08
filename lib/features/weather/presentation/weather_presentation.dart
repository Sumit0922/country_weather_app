import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

abstract final class WeatherPresentation {
  static String condition(int code) {
    return switch (code) {
      0 => AppStrings.clearSky,
      1 || 2 => AppStrings.partlyCloudy,
      3 => AppStrings.overcast,
      45 || 48 => AppStrings.fog,
      51 || 53 || 55 => AppStrings.drizzle,
      56 || 57 => AppStrings.freezingDrizzle,
      61 || 63 || 65 => AppStrings.rain,
      66 || 67 => AppStrings.freezingRain,
      71 || 73 || 75 => AppStrings.snow,
      77 => AppStrings.snowGrains,
      80 || 81 || 82 => AppStrings.rainShowers,
      85 || 86 => AppStrings.snowShowers,
      95 || 96 || 99 => AppStrings.thunderstorm,
      _ => AppStrings.unknownWeather,
    };
  }

  static IconData icon(int code) {
    return switch (code) {
      0 => Icons.wb_sunny_outlined,
      1 || 2 => Icons.wb_cloudy_outlined,
      3 || 45 || 48 => Icons.cloud_outlined,
      71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit,
      95 || 96 || 99 => Icons.thunderstorm_outlined,
      51 ||
      53 ||
      55 ||
      56 ||
      57 ||
      61 ||
      63 ||
      65 ||
      66 ||
      67 ||
      80 ||
      81 ||
      82 => Icons.water_drop_outlined,
      _ => Icons.cloud_outlined,
    };
  }
}
