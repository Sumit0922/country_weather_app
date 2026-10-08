import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../widgets/app_feedback.dart';
import '../../../widgets/app_state_view.dart';
import '../../../widgets/content_card.dart';
import '../../countries/domain/country.dart';
import '../domain/weather.dart';
import 'weather_presentation.dart';
import 'weather_view_model.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({required this.country, super.key});

  final Country country;

  Future<void> _openCredit() async {
    try {
      final opened = await launchUrl(
        Uri.parse(AppConfig.weatherAttributionUrl),
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        AppFeedback.error(AppStrings.linkFailed);
      }
    } catch (_) {
      AppFeedback.error(AppStrings.linkFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider(country));

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_outlined, color: AppColors.primary),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  AppStrings.currentWeather,
                  style: TextStyle(
                    fontSize: 18.spMin,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: AppStrings.refresh,
                onPressed: weather.isLoading
                    ? null
                    : () {
                        ref.invalidate(weatherProvider(country));
                      },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Text(
            AppStrings.weatherAtLocation,
            style: TextStyle(fontSize: 12.spMin, color: AppColors.muted),
          ),
          18.verticalSpace,
          weather.when(
            skipLoadingOnRefresh: false,
            loading: () => const AppStateView(
              title: AppStrings.loadingWeather,
              loading: true,
            ),
            error: (error, stackTrace) => AppStateView(
              title: AppStrings.weatherLoadError,
              message: ErrorMessage.from(error),
              icon: Icons.cloud_off_outlined,
              onRetry: () {
                ref.invalidate(weatherProvider(country));
              },
            ),
            data: (data) => _WeatherContent(weather: data),
          ),
          12.verticalSpace,
          TextButton(
            onPressed: _openCredit,
            child: const Text(AppStrings.weatherCredit),
          ),
        ],
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduceMotion ? Duration.zero : AppConfig.animationDuration,
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  WeatherPresentation.icon(weather.code),
                  color: AppColors.primary,
                  size: 44.r,
                ),
                10.verticalSpace,
                _AnimatedWeatherValue(
                  value: weather.temperature,
                  format: AppStrings.temperatureValue,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 38.spMin,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                6.verticalSpace,
                Text(
                  WeatherPresentation.condition(weather.code),
                  style: TextStyle(
                    fontSize: 15.spMin,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          14.verticalSpace,
          LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
              final stackMetrics =
                  constraints.maxWidth < 280 || textScale > 1.4;

              final humidity = _WeatherMetric(
                icon: Icons.water_drop_outlined,
                label: AppStrings.humidity,
                value: weather.humidity,
                format: AppStrings.humidityValue,
              );

              final wind = _WeatherMetric(
                icon: Icons.air,
                label: AppStrings.windSpeed,
                value: weather.windSpeed,
                format: AppStrings.windValue,
              );

              if (stackMetrics) {
                return Column(children: [humidity, 10.verticalSpace, wind]);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: humidity),
                  10.horizontalSpace,
                  Expanded(child: wind),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.format,
  });

  final IconData icon;
  final String label;
  final double value;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22.r),
          10.verticalSpace,
          Text(
            label,
            style: TextStyle(color: AppColors.muted, fontSize: 12.spMin),
          ),
          5.verticalSpace,
          _AnimatedWeatherValue(
            value: value,
            format: format,
            style: TextStyle(fontSize: 19.spMin, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AnimatedWeatherValue extends StatelessWidget {
  const _AnimatedWeatherValue({
    required this.value,
    required this.format,
    required this.style,
  });

  final double value;
  final String Function(double) format;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: format(value),
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: reduceMotion
              ? Duration.zero
              : AppConfig.metricAnimationDuration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return Text(format(animatedValue), style: style);
          },
        ),
      ),
    );
  }
}
